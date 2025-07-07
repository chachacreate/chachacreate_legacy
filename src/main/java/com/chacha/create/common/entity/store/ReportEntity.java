package com.chacha.create.common.entity.store;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 신고 정보(Report)를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code report} 테이블과 매핑되며,
 * 회원이 판매자를 신고한 기록을 저장합니다.
 * </p>
 *
 * <pre>
 * 필드 설명:
 * - reportId     : 신고 고유 ID (기본 키)
 * - memberId     : 신고한 회원의 ID (외래키)
 * - sellerId     : 신고 대상 판매자의 ID (외래키)
 * - reportDate   : 신고한 날짜 및 시간
 * - reportTitle  : 신고 제목
 * - reportText   : 신고 상세 내용 (DB에서는 CLOB 타입으로 저장)
 * </pre>
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ReportEntity {

    /** 신고 고유 ID */
    private Integer reportId;

    /** 신고한 회원 ID */
    private Integer memberId;

    /** 신고 대상 판매자 ID */
    private Integer sellerId;

    /** 신고 일자 */
    private Date reportDate;

    /** 신고 제목 */
    private String reportTitle;

    /** 신고 내용 (DB에서 CLOB 타입으로 저장됨) */
    private String reportText;
    
    /** 신고대상(판매자) ID 검증용*/
    private Integer storeId;
    
    /** 신고당하는 대상 구분용 **/
    private Integer memberCheck;
}
