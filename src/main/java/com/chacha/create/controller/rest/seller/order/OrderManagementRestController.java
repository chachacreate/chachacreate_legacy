package com.chacha.create.controller.rest.seller.order;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.service.seller.order.OrderManagementService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/{storeUrl}/seller")
public class OrderManagementRestController {

	@Autowired
	OrderManagementService orderManagementService;
	
//	@GetMapping(value = "/management/order", produces = MediaType.APPLICATION_JSON_VALUE)
//    public ResponseEntity<ApiResponse<List<OrderDTO>>> orderManagement(@PathVariable String storeUrl) {
//        List<OrderDTO> orders = orderManagementService.selectOrderAll(storeUrl);
//        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "전체 주문 목록 조회 성공", orders));
//    }

    @GetMapping(value = "/refunds", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<List<OrderDTO>>> refundList(@PathVariable String storeUrl) {
        List<OrderDTO> refunds = orderManagementService.selectRefundAll(storeUrl);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "환불 목록 조회 성공", refunds));
    }

//    @GetMapping(value = "/orderstatus", produces = MediaType.APPLICATION_JSON_VALUE)
//    public ResponseEntity<ApiResponse<List<OrderDTO>>> orderStatusList(@PathVariable String storeUrl,
//                                                                       @RequestParam OrderStatusEnum orderStatus) {
//        List<OrderDTO> ordersByStatus = orderManagementService.selectForOrderStatus(storeUrl, orderStatus);
//        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "주문 상태별 목록 조회 성공", ordersByStatus));
//    }

    @PutMapping(value = "/orderstatus", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> updateOrderStatus(@RequestBody OrderInfoEntity orderInfoEntity) {
        int result = orderManagementService.updateForRefundStatus(orderInfoEntity);

        if (result <= 0) {
            throw new InvalidRequestException("주문 상태 수정 실패");
        }

        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "주문 상태 수정 성공"));
    }
    
    // 주문 목록 조회 (전체 + 상태별 + 페이지네이션 기능 추가)
    @GetMapping("/management/orders")
    public ApiResponse<List<OrderDTO>> getOrders(
            @PathVariable String storeUrl,
            @RequestParam(value = "status", required = false, defaultValue = "all") String status,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {

        log.info("판매자 주문 목록 조회: storeUrl={}, status={}, page={}, size={}", storeUrl, status, page, size);

        int offset = (page - 1) * size;
        List<OrderDTO> orders;

        if (status.equalsIgnoreCase("ALL")) {
            orders = orderManagementService.selectOrderAll(storeUrl, offset, size);
            return new ApiResponse<>(ResponseCode.ORDER_NOT_STATUS, orders);
        }

        try {
            OrderStatusEnum statusEnum = OrderStatusEnum.from(status);
            orders = orderManagementService.selectForOrderStatus(storeUrl, statusEnum, offset, size);
            return new ApiResponse<>(ResponseCode.ORDER_STATUS_OK, orders);
        } catch (IllegalArgumentException e) {
            orders = orderManagementService.selectOrderAll(storeUrl, offset, size);
            return new ApiResponse<>(ResponseCode.ORDER_STATUS_FAIL, "잘못된 status 값 → 전체 주문 조회", orders);
        }
    }


	
}
