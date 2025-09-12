package com.chacha.create.controller.rest.mainhome.personal;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.service.mainhome.personal.OrderManageService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/main/sell")
public class PersonalOrderManageRestController {

    @Autowired
    private OrderManageService orderManageService;

    @GetMapping("/order/management")
    public ResponseEntity<ApiResponse<List<OrderDTO>>> orderManagement(HttpSession session) {
        MemberEntity memberEntity = (MemberEntity) session.getAttribute("loginMember");
        log.info("loginMember={}", memberEntity);
        List<OrderDTO> orders = orderManageService.selectOrderAll(memberEntity);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, orders));
    }

    @GetMapping("/refunds")
    public ResponseEntity<ApiResponse<List<OrderDTO>>> refundlist(HttpSession session) {
        MemberEntity memberEntity = (MemberEntity) session.getAttribute("loginMember");
        List<OrderDTO> refunds = orderManageService.selectRefundAll(memberEntity);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, refunds));
    }

    @GetMapping("/orderstatus")
    public ResponseEntity<ApiResponse<List<OrderDTO>>> orderStatuslist(HttpSession session, OrderStatusEnum orderStatus) {
        MemberEntity memberEntity = (MemberEntity) session.getAttribute("loginMember");
        List<OrderDTO> filteredOrders = orderManageService.selectForOrderStatus(memberEntity, orderStatus);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, filteredOrders));
    }

    @PutMapping("/orderstatus")
    public ResponseEntity<ApiResponse<Integer>> updateOrderStatus(@RequestBody OrderInfoEntity body) {
        if (body.getOrderId() == 0 || body.getOrderStatus() == null) {
            return ResponseEntity
              .status(ResponseCode.BAD_REQUEST.getStatus())
              .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, 0));
        }
        int result = orderManageService.updateForOrderStatus(body.getOrderId(), body.getOrderStatus());
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }

}
