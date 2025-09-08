package com.chacha.create.common.dto.order;

import java.util.List;

import com.chacha.create.common.dto.boot.BootAddressDTO;
import com.chacha.create.common.entity.order.OrderDetailEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderRequestDTO {
	
    private OrderInfoEntity orderInfo;
    private List<OrderDetailEntity> detailList;
    private BootAddressDTO bootAddr;
    
    // 새 배송지 입력 여부
    private Boolean newAddr;
    
}