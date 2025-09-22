package com.chacha.create.common.dto.order.inventory;

import lombok.Getter; import lombok.Setter;

@Getter @Setter
public class OrderItemsRow {
    private Long productId;
    private Integer quantity; // ORDER_DETAIL 수량 합
}
