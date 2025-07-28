package com.chacha.create.controller.websocket;

import java.net.URI;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.util.UriComponentsBuilder;

import com.chacha.create.common.dto.chat.MessageDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.service.store_common.header.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/**
 * WebSocket을 통해 채팅 메시지를 송수신하는 핸들러입니다.
 * 사용자 인증, 채팅방 입장, 메시지 브로드캐스팅, 연결 해제 및 에러 처리를 담당합니다.
 * 
 * WebSocket 연결 시 HttpSession에서 로그인 정보를 받아오며, storeUrl 또는 chatroomId 쿼리 파라미터를 통해 채팅방 식별자를 결정합니다.
 * 
 * @author 
 */
@Component
@Slf4j
public class ChatHandler extends TextWebSocketHandler {

    /** 채팅방 ID별로 연결된 WebSocket 세션 목록을 관리하는 맵 */
    private static final Map<Integer, List<WebSocketSession>> chatroomSessions = new ConcurrentHashMap<>();

    /** JSON 직렬화 및 역직렬화를 위한 ObjectMapper */
    private final ObjectMapper objectMapper = new ObjectMapper();

    /** 메시지 저장 및 채팅방 생성 등의 로직을 처리하는 서비스 */
    @Autowired
    private MessageService messageService;

    @Autowired
    private StoreMapper storeMapper;
    
    @Autowired
    private SellerMapper sellerMapper;
    
    /**
     * 클라이언트가 WebSocket 연결을 성공적으로 맺은 후 호출됩니다.
     * 로그인 여부 확인, 채팅방 ID 파싱 및 세션 저장 등의 초기 처리를 수행합니다.
     *
     * @param session 연결된 WebSocket 세션
     * @throws Exception 예외 발생 시
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        MemberEntity loginMember = (MemberEntity) session.getAttributes().get("loginMember");
        boolean fromstore = false;
        if (loginMember == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("로그인 필요"));
            return;
        }
        // 🔽 interceptor에서 저장한 chatroomId 우선 사용
        Integer chatroomId = (Integer) session.getAttributes().get("chatroomId");
        try {
        	fromstore = (boolean) session.getAttributes().get("fromstore").equals("true");
        }catch (Exception e) {
        	log.info("fromstore 없음");
        	fromstore = false;
        }

        if (chatroomId == null) {
            // fallback: URI 쿼리 파라미터에서 추출 (storeUrl 기반)
            URI uri = session.getUri();
            if (uri == null) {
                session.close(CloseStatus.BAD_DATA.withReason("URI 없음"));
                return;
            }

            Map<String, String> queryParams = UriComponentsBuilder.fromUri(uri).build().getQueryParams().toSingleValueMap();
            String storeUrl = queryParams.get("storeUrl");

            if (storeUrl != null) {
                chatroomId = messageService.makeChattingInStore(loginMember, storeUrl);
            }
        }

        if (chatroomId == null) {
            session.close(CloseStatus.BAD_DATA.withReason("chatroomId 또는 storeUrl 필요"));
            return;
        }
        session.getAttributes().put("chatroomId", chatroomId);
        chatroomSessions.computeIfAbsent(chatroomId, k -> new CopyOnWriteArrayList<>()).add(session);

        log.info("채팅방 {}에 사용자 {} 입장", chatroomId, loginMember.getMemberId());
        List<MessageDTO> oldMessages = null;
        log.info("fromstore : " + fromstore);
        if (fromstore) {
        	int storeId = storeMapper.selectBySellerId(sellerMapper.selectByMemberId(loginMember.getMemberId()).getSellerId()).getStoreId();
        	log.info("스토어 ID : " + storeId);
        	oldMessages = messageService.getMemberStoreAllMessage(storeId, chatroomId);
        }else {
        	oldMessages = messageService.getMemberStoreAllMessage(loginMember, chatroomId);
        }
        log.info("기존 메시지 개수: {}", oldMessages.size());
        for (MessageDTO msg : oldMessages) {
            session.sendMessage(new TextMessage(objectMapper.writeValueAsString(msg)));
        }
    }

    /**
     * 클라이언트로부터 텍스트 메시지를 수신했을 때 호출됩니다.
     * 메시지를 파싱하여 DB에 저장하고, 동일한 채팅방의 모든 클라이언트에게 브로드캐스트합니다.
     *
     * @param session 메시지를 보낸 WebSocket 세션
     * @param message 수신된 텍스트 메시지
     * @throws Exception 예외 발생 시
     */
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        MemberEntity loginMember = (MemberEntity) session.getAttributes().get("loginMember");
        Integer chatroomId = (Integer) session.getAttributes().get("chatroomId");

        if (loginMember == null || chatroomId == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("잘못된 세션 정보"));
            return;
        }

        MessageDTO messageDTO = objectMapper.readValue(message.getPayload(), MessageDTO.class);
        messageDTO.setMemberId(loginMember.getMemberId());
        messageDTO.setChatroomId(chatroomId);
        // 현재 시간(Date 타입) 설정
        LocalDateTime now = LocalDateTime.now();
        Date nowDate = Date.from(now.atZone(ZoneId.systemDefault()).toInstant());
        messageDTO.setChattingDate(nowDate);

        // 메시지 저장
        messageService.makeChattingInMyPage(messageDTO);

        // 같은 채팅방의 사용자에게 메시지 전송
        for (WebSocketSession ws : chatroomSessions.getOrDefault(chatroomId, List.of())) {
            if (ws.isOpen()) {
                ws.sendMessage(new TextMessage(objectMapper.writeValueAsString(messageDTO)));
            }
        }
    }

    /**
     * WebSocket 연결이 종료되었을 때 호출됩니다.
     * 세션을 채팅방 목록에서 제거합니다.
     *
     * @param session 종료된 WebSocket 세션
     * @param status  종료 상태
     * @throws Exception 예외 발생 시
     */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        Integer chatroomId = (Integer) session.getAttributes().get("chatroomId");
        if (chatroomId != null) {
            chatroomSessions.getOrDefault(chatroomId, List.of()).remove(session);
        }
    }

    /**
     * WebSocket 통신 중 에러가 발생했을 때 호출됩니다.
     * 로그를 남기고 세션을 종료합니다.
     *
     * @param session   에러가 발생한 WebSocket 세션
     * @param exception 발생한 예외 객체
     * @throws Exception 예외 발생 시
     */
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        log.error("WebSocket 에러 발생: {}", exception.getMessage(), exception);
        session.close(CloseStatus.SERVER_ERROR);
    }
}
