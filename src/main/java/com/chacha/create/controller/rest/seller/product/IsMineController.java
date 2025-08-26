package com.chacha.create.controller.rest.seller.product;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.product.IsMineService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/auth/editable/{productId}")
public class IsMineController {
	
	@Autowired
	IsMineService isMineService;
	
    @GetMapping
    public ResponseEntity<ApiResponse<?>> placeOrder(@PathVariable int productId, HttpSession session) {
        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");

        boolean editable = isMineService.isEditableByMember(productId, loginMember.getMemberId());

        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, editable));
    }
}
