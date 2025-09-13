package com.chacha.create.common.dto.boot;

import com.chacha.create.common.enums.order.OrderStatusEnum;

import lombok.Data;

@Data
public class BootOrderStatusRequestDTO {
    private int orderDetailId;
    private OrderStatusEnum orderStatus;
}