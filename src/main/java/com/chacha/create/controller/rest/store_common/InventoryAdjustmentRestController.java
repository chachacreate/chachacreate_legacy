package com.chacha.create.controller.rest.store_common;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.dto.order.inventory.InventoryAdjustResponse;
import com.chacha.create.service.store_common.InventoryAdjustmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@CrossOrigin(
	    origins = {"http://localhost","http://localhost:5173","http://localhost:3000"},
	    allowCredentials = "true"
	)
@RequestMapping("/legacy/inventory/adjustments")
public class InventoryAdjustmentRestController {

    private final InventoryAdjustmentService service;

    // 주문 완료 → 재고 차감 (orderId만)
    @PostMapping(value="/orders/{orderId}", produces=MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<InventoryAdjustResponse>> decreaseByOrderId(@PathVariable Long orderId) {
        var res = service.applyDecreaseByOrderId(orderId);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, res));
    }
    

}
