package com.chacha.create.common.dto.chat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChatRoomInfoDTO {
	private Integer chatroomId;
	private String storeName;
	private Integer memberId;
	private String memberName;
	private String chattingText;
	private String storeUrl;
}