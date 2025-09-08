package com.chacha.create.common.dto.order;

import java.sql.Date;
import java.util.List;

import com.chacha.create.common.enums.order.OrderStatusEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetailDTO {
	
	// 주문 상품 리스트
    private List<OrderListDTO> orderItems;
	
	private Integer orderId;
    private Integer memberId;
    private Date orderDate;
    private String orderName;
    private String orderPhone;
    private OrderStatusEnum orderStatus;

    // 주소 정보
    private Integer addressId;
    private String postNum;
    private String addressRoad;
    private String addressDetail;
    private String addressExtra;

    // 카드 정보
    private String maskedCardNum;
    private String cardCompany;

    // 가공 필드
    private boolean canCancel;
    private boolean canRefund;
    private boolean canWriteReview;
    private Integer totalAmount;
}