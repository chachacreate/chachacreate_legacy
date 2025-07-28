package com.chacha.create.common.entity.member;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AlterMessageEntity {
	private Integer alterMessageId;     // 알림 메시지 ID
    private Integer memberId;           // 회원 ID (외래키)
    private String messageTitle;     // 메시지 제목
    private String messageContent;   // 메시지 내용
}
