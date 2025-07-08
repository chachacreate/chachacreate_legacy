package com.chacha.create.common.mapper.chat;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.dto.chat.ChatRoomInfoDTO;
import com.chacha.create.common.dto.chat.MessageDTO;

@Mapper
public interface MessageMapper {

	List<MessageDTO> selectByChatroomId(MessageDTO messageDTO);
	List<MessageDTO> selectByMemberId(int memberId);
	List<MessageDTO> selectForMemberWithStoreAllMessage(MessageDTO messageDTO);
	List<MessageDTO> selectForMemberWithStoreURlAllMessage(MessageDTO messageDTO);
	MessageDTO selectForGetChatRoomIdByStoreURl(MessageDTO messageDTO);
	
	int insertChatroom(MessageDTO messageDTO);
	int insertChatting(MessageDTO messageDTO);
	List<ChatRoomInfoDTO> selectForStoreNameByMemberId(Integer memberId);
	List<MessageDTO> selectForMemberWithChatroomIdAllMessage(MessageDTO messageDTO);
	List<ChatRoomInfoDTO> selectForStoreNameByStoreUrl(String storeUrl);
	List<MessageDTO> selectForStoreWithChatroomIdAllMessage(MessageDTO messageDTO);
}
