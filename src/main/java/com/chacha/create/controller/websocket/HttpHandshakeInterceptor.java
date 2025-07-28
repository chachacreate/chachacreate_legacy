package com.chacha.create.controller.websocket;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import com.chacha.create.common.entity.member.MemberEntity;

import lombok.extern.slf4j.Slf4j;

/**
 * WebSocket 핸드셰이크 과정에서 HTTP 세션의 로그인 사용자 정보를 WebSocket 세션으로 전달하는 인터셉터입니다.
 * 
 * 이 인터셉터는 WebSocket 연결 요청 시 세션에서 'loginMember' 속성을 추출하여,
 * WebSocket 세션의 attributes에 저장함으로써 이후 메시지 핸들링 과정에서 로그인 사용자 정보를 활용할 수 있도록 합니다.
 * 
 * @author 
 */
@Slf4j
@Component
public class HttpHandshakeInterceptor implements HandshakeInterceptor {

    /**
     * WebSocket 핸드셰이크 전에 호출되어, HTTP 세션에서 로그인한 회원 정보를 WebSocket 세션 속성으로 전달합니다.
     *
     * @param request       WebSocket 연결 요청에 대한 HTTP 요청 객체
     * @param response      WebSocket 연결 응답에 대한 HTTP 응답 객체
     * @param wsHandler     WebSocket 핸들러 객체
     * @param attributes    WebSocket 세션에서 사용할 속성 맵
     * @return              핸드셰이크 진행 여부 (true 반환 시 계속 진행)
     * @throws Exception    예외 발생 시
     */
	 @Override
	    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
	                                   WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {

	        if (request instanceof ServletServerHttpRequest) {
	            HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
	            HttpSession session = servletRequest.getSession(false); // 기존 세션만 반환

	            if (session != null) {
	                log.info("세션 ID: {}", session.getId());

	                MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
	                if (loginMember != null) {
	                    log.info("WebSocket에 접속한 로그인한 member 정보: {}", loginMember);
	                    attributes.put("loginMember", loginMember);
	                } else {
	                    log.warn("WebSocket 요청 시 loginMember 세션 속성이 null입니다.");
	                }

	                // chatroomId 파라미터 추출
	                String chatroomIdStr = servletRequest.getParameter("chatroomId");
	                if (chatroomIdStr != null) {
	                    try {
	                        Integer chatroomId = Integer.parseInt(chatroomIdStr);
	                        attributes.put("chatroomId", chatroomId);
	                        log.info("WebSocket 요청 파라미터에서 추출한 chatroomId: {}", chatroomId);
	                    } catch (NumberFormatException e) {
	                        log.warn("잘못된 chatroomId 형식: {}", chatroomIdStr);
	                    }
	                }
	                // fromstore 파라미터 추출
	                String fromstore = servletRequest.getParameter("fromstore");
	                if (fromstore != null) {
	                	try {
	                		attributes.put("fromstore", fromstore);
	                		log.info("WebSocket 요청 파라미터에서 추출한 fromstore: {}", fromstore);
	                	} catch (NumberFormatException e) {
	                		log.warn("잘못된 fromstore 형식: {}", fromstore);
	                	}
	                }

	            } else {
	                log.warn("WebSocket 요청 시 HttpSession이 존재하지 않습니다.");
	            }
	        }

	        return true;
	    }

    /**
     * WebSocket 핸드셰이크 후 호출되는 메서드입니다.
     * 현재는 별도의 후처리 작업을 수행하지 않습니다.
     *
     * @param request    WebSocket 연결 요청에 대한 HTTP 요청 객체
     * @param response   WebSocket 연결 응답에 대한 HTTP 응답 객체
     * @param wsHandler  WebSocket 핸들러 객체
     * @param exception  핸드셰이크 도중 발생한 예외 (없을 경우 null)
     */
    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
                               Exception exception) {
    	log.info("웹소켓 연결 종료");
    }
}
