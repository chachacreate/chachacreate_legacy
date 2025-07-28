package com.chacha.create.common.entity.order;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상품 리뷰 정보를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code review} 테이블과 매핑되며,
 * 주문 상세(order_detail)과 연관된 리뷰 데이터를 관리합니다.
 * </p>
 *
 * <pre>
 * 필드 설명:
 * reviewId       : 리뷰 고유 ID (기본 키)
 * orderDetailId  : 리뷰가 작성된 주문 상세 ID (외래키)
 * reviewDate     : 리뷰 작성일
 * reviewText     : 리뷰 내용 (DB에서는 CLOB 타입으로 저장)
 * </pre>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewEntity {
    /**
     * 리뷰 고유 ID (기본 키)
     */
    private Integer reviewId;

    /**
     * 리뷰가 작성된 주문 상세 ID
     */
    private Integer orderDetailId;

    /**
     * 리뷰 작성일
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date reviewDate;

    /**
     * 리뷰 내용 (DB에서는 CLOB 타입)
     */
    private String reviewText;
}
