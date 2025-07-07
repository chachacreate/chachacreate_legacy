package com.chacha.create.common.dto.chat;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MessageDTO {
	private Integer chatroomId;
	private Integer storeId;
	private Integer memberId;
	private String chattingText;
	private String storeUrl;
    private Date chattingDate;
    private Integer memberCheck;
}
