package com.chacha.create.common.mapper.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.dto.order.inventory.OrderItemsRow;

@Mapper
public interface InventoryAdjustmentMapper {

    /** 주문 상세 → productId별 수량 합계 (상태 필터 없이) */
    List<OrderItemsRow> selectOrderItems(@Param("orderId") Long orderId);

    /** 재고 차감(충분할 때만) */
    int decreaseStockIfEnough(@Param("productId") Long productId,
                              @Param("quantity") Integer quantity);


}
