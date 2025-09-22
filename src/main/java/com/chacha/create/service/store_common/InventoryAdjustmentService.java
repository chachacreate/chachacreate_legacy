package com.chacha.create.service.store_common;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.order.inventory.InventoryAdjustResponse;
import com.chacha.create.common.dto.order.inventory.OrderItemsRow;
import com.chacha.create.common.mapper.order.InventoryAdjustmentMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class InventoryAdjustmentService {

    private final InventoryAdjustmentMapper mapper;

    /**
     * 주문 번호로 주문 상세(상품, 수량)를 읽어 재고만 차감한다.
     * - ORDER_INFO/ORDER_DETAIL 상태값은 건드리지 않음 (ORDER_OK 유지)
     * - 멱등/중복 방지는 하지 않음(같은 주문을 두 번 호출하면 두 번 깎임) → 프론트에서 1회만 호출하도록 가드
     */
    @Transactional
    public InventoryAdjustResponse applyDecreaseByOrderId(Long orderId) {

        // 1) 주문 상세 집계 (상태 필터 없이 order_id 기준으로 전부)
        List<OrderItemsRow> items = mapper.selectOrderItems(orderId);
        if (items == null || items.isEmpty()) {
            return InventoryAdjustResponse.builder()
                    .message("NO_ITEMS")
                    .processedCount(0)
                    .productIds(List.of())
                    .build();
        }

        // 2) 재고 차감 (stock >= qty 조건으로 음수 방지)
        List<Long> touched = new ArrayList<>();
        for (OrderItemsRow it : items) {
            int updated = mapper.decreaseStockIfEnough(it.getProductId(), it.getQuantity());
            if (updated == 0) {
                // 재고 부족 또는 상품 없음 → 전체 롤백
                throw new IllegalStateException("INSUFFICIENT_STOCK or PRODUCT_NOT_FOUND: productId=" + it.getProductId());
            }
            touched.add(it.getProductId());
        }

        return InventoryAdjustResponse.builder()
                .message("APPLIED")
                .processedCount(touched.size())
                .productIds(touched)
                .build();
    }
    
    
}
