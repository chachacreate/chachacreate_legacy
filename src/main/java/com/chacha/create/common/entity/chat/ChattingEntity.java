package com.chacha.create.common.entity.chat;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 채팅 메시지를 나타내는 엔티티 클래스입니다.
 * <p>
 * 이 클래스는 DB의 {@code chatting} 테이블과 매핑되며,
 * 특정 채팅방에서 주고받은 메시지를 저장합니다.
 * </p>
 *
 * <pre>
 * 예시:
 * - chattingId: 101 (채팅 메시지 ID)
 * - chatroomId: 12 (해당 채팅방 ID)
 * - chattingText: "안녕하세요!"
 * - chattingDate: 2025-06-18
 * </pre>
 * 
 * @author
 */
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class ChattingEntity {

    /**
     * 채팅 메시지 ID (기본 키)
     */
    private Integer chattingId;

    /**
     * 메시지가 속한 채팅방 ID (외래키)
     */
    private Integer chatroomId;

    /**
     * 채팅 내용 (텍스트 메시지)
     */
    private String chattingText;

    /**
     * 메시지가 전송된 날짜 (시간 정보가 필요한 경우 {@code java.sql.Timestamp}를 사용 권장)
     */
    private Date chattingDate;
    
    /**
     * 채팅을 스토어에서 보냈는지 member가 보냈는지 확인, member가 보냈으면 1, store가 보냈으면 0
     */
    private Integer memberCheck;
}
