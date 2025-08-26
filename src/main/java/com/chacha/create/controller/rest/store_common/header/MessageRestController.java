package com.chacha.create.controller.rest.store_common.header;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.chat.ChatRoomInfoDTO;
import com.chacha.create.common.dto.chat.ChatroomWithMessagesDTO;
import com.chacha.create.common.dto.chat.MessageDTO;
import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.exception.SessionExpiredException;
import com.chacha.create.service.store_common.header.MessageService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}/message")
public class MessageRestController {

	@Autowired
	MessageService messageService;

	private static final String MAIN_PAGE = "main";

	@GetMapping("/messages")
	public ResponseEntity<ApiResponse<List<MessageDTO>>> getAllMessage(@PathVariable String storeUrl,
			@RequestParam(value = "chatroomId", required = false) Integer chatroomId, HttpSession session) {

		MemberEntity member = getSessionMember(session);

		List<MessageDTO> messages = MAIN_PAGE.equals(storeUrl)
				? messageService.getMemberStoreAllMessage(member, chatroomId)
				: messageService.getMemberStoreAllMessage(member, storeUrl);

		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, messages));
	}

	@GetMapping("/chatrooms")
    public ResponseEntity<ApiResponse<List<ChatRoomInfoDTO>>> getChatroomList(HttpSession session, @PathVariable String storeUrl) {
        MemberEntity member = getSessionMember(session);
        List<ChatRoomInfoDTO> chatrooms = null;
        if(storeUrl.equals("main")) {
        	log.info("main에서 접속");
        	chatrooms = messageService.getMemberAllChatroom(member);
        }else {
        	log.info(storeUrl + "에서 접속");
        	chatrooms = messageService.getMemberStoreAllChatroom(member, storeUrl);
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, chatrooms));
    }

	@PostMapping("/makeChatting")
	public ResponseEntity<ApiResponse<Integer>> makeChatting(@PathVariable String storeUrl,
			HttpSession session) {

		MemberEntity member = getSessionMember(session);
		int result = 0;
		 if(!MAIN_PAGE.equals(storeUrl)) {
			 result = messageService.makeChattingInStore(member, storeUrl);
		 }

		if (result > 0) {
			return ResponseEntity.status(ResponseCode.CREATED.getStatus())
					.body(new ApiResponse<>(ResponseCode.CREATED, result));
		} else {
			throw new IllegalStateException("채팅 생성 실패");
		}
	}

	private MemberEntity getSessionMember(HttpSession session) {
		MemberEntity member = (MemberEntity) session.getAttribute("loginMember");
		if (member == null) {
			throw new SessionExpiredException();
		}
		return member;
	}

	@PostMapping("/open/store")
	public ResponseEntity<ApiResponse<ChatroomWithMessagesDTO>> openChatroomInStore(
			@RequestParam("storeUrl") String storeUrl, HttpSession session) {
		MemberEntity loginMember = getSessionMember(session);

		// 채팅방 + 메시지 불러오기
		ChatroomWithMessagesDTO result = messageService.makeChattingInStoreWithMessages(loginMember, storeUrl);
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
	}
}
