package com.chacha.create.controller.rest.buyer.order;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.order.OrderRequestDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.mypage.MyOrderService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}/order")
public class OrderRestController {

    @Autowired
    private MyOrderService orderService;

    @PostMapping
    public ResponseEntity<ApiResponse<Integer>> placeOrder(@RequestBody OrderRequestDTO orderRequest,
                                                          HttpSession session) {
        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        log.info("주문 요청 - 사용자ID: {}, 주문정보: {}", loginMember.getMemberId(), orderRequest);

        int resultOrderId = orderService.placeOrder(orderRequest, loginMember);

        if (resultOrderId > 0) {
            String message = "주문이 완료되었습니다. 주문번호: " + resultOrderId;
            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.CREATED, resultOrderId));
        } else {
            String errorMessage = "주문 처리에 실패했습니다.";
            return ResponseEntity.status(ResponseCode.BAD_REQUEST.getStatus())
                    .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, errorMessage));
        }
    }
    
    
   
    @GetMapping("/{memberId}/products/{productId}/orderdetail")
    public ResponseEntity<ApiResponse<Integer>> getOrderDetailId(@PathVariable("storeUrl") String storeUrl,
            							@PathVariable("memberId") int memberId, @PathVariable("productId") int productId) {

        Integer orderDetailId = orderService.selectForOrderDetailId(memberId, productId);

        if (orderDetailId == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, null));
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, orderDetailId));
    }
}
