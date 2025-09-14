package com.chacha.create.common.dto.order;

import java.sql.Date;

import com.chacha.create.common.enums.order.OrderStatusEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderListDTO {
	
	// store
	private String storeUrl;
	private String storeName;
	
	
	// OrderInfoEntity
	private int orderId;
	private Date orderDate;
	
	// OrderDetailEntity
	private int orderDetailId;
	private OrderStatusEnum orderStatus;
    
    // ProductEntity
	private int productId;
    private String productName;
    private String productDetail;
    
    // PImgEntity
    private String pimgUrl;
    
    // OrderDetailEntity
    private Integer orderCnt;
    private Integer orderPrice;
    
//    // DeliveryEntity
//    private Integer deliveryCheck;
//    
//    // 배송 상태 문자열로 표현
//    private String deliveryStatus;
}