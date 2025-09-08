package com.chacha.create.common.entity.order;

import com.chacha.create.common.enums.order.OrderStatusEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 주문 상세 정보를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code order_detail} 테이블과 매핑되며,
 * 하나의 주문에 포함된 각 상품별 수량과 가격 정보를 관리합니다.
 * </p>
 *
 * <pre>
 * 필드 설명:
 * orderDetailId : 주문 상세 고유 ID (기본 키)
 * orderId       : 주문 ID (외래키, order 테이블과 연관)
 * productId     : 상품 ID (외래키, product 테이블과 연관)
 * orderCnt      : 주문한 상품 수량
 * orderPrice    : 주문 시점의 상품 단가 또는 총 가격
 * </pre>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetailEntity {
    /**
     * 주문 상세 고유 ID (기본 키)
     */
    private Integer orderDetailId;

    /**
     * 주문 ID (외래키)
     */
    private Integer orderId;

    /**
     * 상품 ID (외래키)
     */
    private Integer productId;

    /**
     * 주문한 상품 수량
     */
    private Integer orderCnt;

    /**
     * 주문 시점의 상품 가격 (단가 또는 총액)
     */
    private Integer orderPrice;
    
    // 주문 상태 추가
    private OrderStatusEnum orderStatus;
}
