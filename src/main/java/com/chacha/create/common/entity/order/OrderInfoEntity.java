package com.chacha.create.common.entity.order;

import java.sql.Date;

import com.chacha.create.common.enums.order.OrderStatusEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 주문 정보를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code order_info} 테이블과 매핑되며,
 * 주문의 기본 정보와 결제, 배송 관련 키를 관리합니다.
 * </p>
 *
 * <pre>
 * 필드 설명:
 * orderId    : 주문 고유 ID (기본 키)
 * memberId   : 주문한 회원의 ID (외래키, member 테이블과 연관)
 * orderDate  : 주문 일자
 * orderName  : 주문자 이름
 * orderPhone : 주문자 연락처
 * addressId  : 배송지 주소 ID (외래키, address 테이블과 연관)
 * cardId     : 결제 카드 ID (외래키, card 테이블과 연관)
 * orderStatus : 처리 상태
 * </pre>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderInfoEntity {
    /**
     * 주문 고유 ID (기본 키)
     */
    private Integer orderId;

    /**
     * 주문한 회원의 ID
     */
    private Integer memberId;

    /**
     * 주문 일자
     */
    private Date orderDate;

    /**
     * 주문자 이름
     */
    private String orderName;

    /**
     * 주문자 연락처
     */
    private String orderPhone;

    /**
     * 배송지 주소 ID
     */
    private Integer addressId;

    /**
     * 결제 카드 ID
     */
    private Integer cardId;
    
    /**
     * 처리 상태
     */
    private OrderStatusEnum orderStatus;
}
