package com.chacha.create.service.store_common.header;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.chat.ChatRoomInfoDTO;
import com.chacha.create.common.dto.chat.ChatroomWithMessagesDTO;
import com.chacha.create.common.dto.chat.MessageDTO;
import com.chacha.create.common.entity.chat.ChatroomEntity;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.mapper.chat.ChatroomMapper;
import com.chacha.create.common.mapper.chat.MessageMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MessageService {

	private final MessageMapper messageMapper;
	private final ChatroomMapper chatroomMapper;
	private final StoreMapper storeMapper;
	
	// 스토어에서 채팅을 열었을 때
	@Transactional(rollbackFor = Exception.class)
	public int makeChattingInStore(MemberEntity memberEntity, String url) {
	    MessageDTO messageDTO = MessageDTO.builder()
	        .storeUrl(url)
	        .memberId(memberEntity.getMemberId())
	        .build();

	    // 1. 기존 채팅방 존재 여부 확인
	    MessageDTO existingChatroom = messageMapper.selectForGetChatRoomIdByStoreURl(messageDTO);
	    log.info("기존 채팅방 확인: {}", existingChatroom);

	    // 2. 이미 존재하면 해당 채팅방 ID 리턴
	    if (existingChatroom != null) {
	        return existingChatroom.getChatroomId();
	    }

	    // 3. 없으면 새로 생성
	    Integer storeId = storeMapper.selectByStoreUrl(url).getStoreId();
	    log.info("스토어 id 확인: {}", storeId);
	    messageDTO.setStoreId(storeId);

	    int inserted = messageMapper.insertChatroom(messageDTO);
	    log.info("채팅방 생성 완료, inserted={}", inserted);

	    return inserted;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public ChatroomWithMessagesDTO makeChattingInStoreWithMessages(MemberEntity memberEntity, String url) {
	    MessageDTO messageDTO = MessageDTO.builder()
	        .storeUrl(url)
	        .memberId(memberEntity.getMemberId())
	        .build();

	    // 기존 채팅방 확인
	    MessageDTO existingChatroom = messageMapper.selectForGetChatRoomIdByStoreURl(messageDTO);
	    log.info("기존 채팅방 확인: {}", existingChatroom);

	    // 없다면 새로 생성
	    if (existingChatroom == null) {
	        Integer storeId = storeMapper.selectByStoreUrl(url).getStoreId();
	        messageDTO.setStoreId(storeId);
	        messageMapper.insertChatroom(messageDTO);
	        existingChatroom = messageMapper.selectForGetChatRoomIdByStoreURl(messageDTO);
	        log.info("새 채팅방 생성: {}", existingChatroom);
	    }

	    // 채팅방 ID 기준으로 메시지 조회
	    List<MessageDTO> messages = messageMapper.selectByChatroomId(
	        MessageDTO.builder()
	            .chatroomId(existingChatroom.getChatroomId())
	            .build()
	    );

	    return ChatroomWithMessagesDTO.builder()
	        .chatroomId(existingChatroom.getChatroomId())
	        .messages(messages)
	        .build();
	}
	
	// 메시지 칸에서 열었을 때
	@Transactional(rollbackFor = Exception.class)
	public int makeChattingInMyPage(MessageDTO messageDTO) {
		int result = 0;
		// messageDTO로 채팅방 id까지 받아 올 예정임
		result = messageMapper.insertChatting(messageDTO);
		return result;
	}
	
	// 로그인한 회원이 가지고있는 모든 채팅방을 확인
	public List<ChatroomEntity> getMembersAllChatroom(MemberEntity memberEntity){
		List<ChatroomEntity> chatroomEntities = null;
		chatroomEntities = chatroomMapper.selectByMemberId(memberEntity.getMemberId());
		return chatroomEntities;
	}
	
	// 회원정보와 스토어 url을 통해 주고받은 메시지를 전부 조회
	public List<MessageDTO> getMemberStoreAllMessage(MemberEntity memberEntity, String url){
		List<MessageDTO> messageDTOs = null;
		
		MessageDTO messageDTO = MessageDTO.builder()
				.storeUrl(url)
				.memberId(memberEntity.getMemberId())
				.build();
		
		messageDTOs = messageMapper.selectForMemberWithStoreURlAllMessage(messageDTO);
		
		return messageDTOs;
	}
	
	// 회원정보와 채팅방 id를 통해 주고받은 메시지를 전부 조회
	public List<MessageDTO> getMemberStoreAllMessage(MemberEntity memberEntity, int chatroomId){
		List<MessageDTO> messageDTOs = null;
		
		MessageDTO messageDTO = MessageDTO.builder()
				.chatroomId(chatroomId)
				.memberId(memberEntity.getMemberId())
				.build();
		
		messageDTOs = messageMapper.selectForMemberWithChatroomIdAllMessage(messageDTO);
		log.info(messageDTOs.toString());
		return messageDTOs;
	}
	
	// 회원정보와 채팅방 id를 통해 주고받은 메시지를 전부 조회
	public List<MessageDTO> getMemberStoreAllMessage(int storeId, int chatroomId){
		List<MessageDTO> messageDTOs = null;
		log.info("현재 스토어 아이디 : " + storeId);
		MessageDTO messageDTO = MessageDTO.builder()
				.chatroomId(chatroomId)
				.storeId(storeId)
				.build();
		
		messageDTOs = messageMapper.selectForStoreWithChatroomIdAllMessage(messageDTO);
		log.info(messageDTOs.toString());
		return messageDTOs;
	}
	
	public List<ChatRoomInfoDTO> getMemberAllChatroom(MemberEntity memberEntity){
		List<ChatRoomInfoDTO> chattingrooms = messageMapper.selectForStoreNameByMemberId(memberEntity.getMemberId());
		log.info(chattingrooms.toString());
		return chattingrooms;
	}

	public List<ChatRoomInfoDTO> getMemberStoreAllChatroom(MemberEntity memberEntity, String storeUrl) {
		List<ChatRoomInfoDTO> chattingrooms = messageMapper.selectForStoreNameByStoreUrl(storeUrl);
		log.info(chattingrooms.toString());
		return chattingrooms;
	}
	
}
