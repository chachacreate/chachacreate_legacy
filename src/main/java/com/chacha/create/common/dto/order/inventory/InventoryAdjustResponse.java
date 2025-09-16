package com.chacha.create.common.dto.order.inventory;

import java.util.List;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor              // ✅ 기본 생성자 추가
@AllArgsConstructor
public class InventoryAdjustResponse {
	private Long orderId;
    private List<Long> orderDetailIds;
    private List<Long> productIds;

    private int processedCount;  // 실제 업데이트된 PRODUCT 행 수
    private int increasedQty;    // 총 증가 수량

    private String message;      // APPLIED / ALREADY_APPLIED_OR_INVALID_STATE / NOT_FOUND
}
