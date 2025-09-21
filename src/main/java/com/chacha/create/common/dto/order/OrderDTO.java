package com.chacha.create.common.dto.order;

import java.sql.Date;

import com.chacha.create.common.enums.order.OrderStatusEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderDTO {
	// order_info 테이블
    private Integer orderId;
    private Integer memberId;
    private Date orderDate;
    private String orderName;
    private OrderStatusEnum orderStatus;

    // order_detail 테이블
    private Integer orderDetailId;
    private Integer orderCnt;
    private Integer orderPrice;
   
    // product 테이블
    private Integer productId;
    private Integer storeId;
    private String productName;
    private Integer price;
    
    // addr 테이블
    private Integer addressId;
    private String postNum;
    private String addressRoad;
    private String addressDetail;
    private String addressExtra;
    
    // card 테이블
    private Integer cardId;
    private String cardNum;
    private String cardCompany;
    
    private String orderStatusLabel; // "발송전" 등 상태 표시용
    private String addressFull;      // 전체 주소 조합용
    
    private Integer totalCount; // 전체 및 상태별 주문 수(페이지네이션용)
}
