package com.chacha.create.common.entity.store;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상점 공지사항 정보를 나타내는 엔티티 클래스
 * <p>
 * DB의 {@code notice} 테이블과 매핑되며,
 * 각 상점(store)이 작성한 공지사항 데이터를 포함합니다.
 * </p>
 *
 * <pre>
 * 필드 설명:
 * - noticeId     : 공지사항 고유 ID (기본 키)
 * - storeId      : 공지사항을 등록한 상점 ID (외래키)
 * - noticeCheck  : 공지 노출 여부 (예: 1 = 노출, 0 = 비노출)
 * - noticeTitle  : 공지사항 제목
 * - noticeText   : 공지사항 본문 (DB에서는 CLOB 타입으로 저장됨)
 * - noticeDate   : 공지 등록일
 * </pre>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NoticeEntity {

    /** 공지사항 고유 ID (기본 키) */
    private Integer noticeId;

    /** 해당 공지를 등록한 상점 ID */
    private Integer storeId;

    /** 공지사항 노출 여부 (1: 노출, 0: 숨김) */
    private Integer noticeCheck;

    /** 공지사항 제목 */
    private String noticeTitle;

    /** 공지사항 본문 내용 (DB에서는 CLOB 타입으로 저장됨) */
    private String noticeText;

    /** 공지사항 등록 일자 */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date noticeDate;
}
