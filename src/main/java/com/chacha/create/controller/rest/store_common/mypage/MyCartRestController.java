package com.chacha.create.controller.rest.store_common.mypage;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.member.CartViewDTO;
import com.chacha.create.common.entity.member.CartEntity;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.mypage.MyCartService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/main/mypage/cart")
public class MyCartRestController {
    @Autowired
    private MyCartService myCartService;

    // 장바구니 상세 정보 조회
    @GetMapping
    public ResponseEntity<ApiResponse<List<CartViewDTO>>> getCartViewList(HttpSession session) {
    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        List<CartViewDTO> result = myCartService.selectForCartViewList(loginMember.getMemberId());
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }

    // 장바구니 상품 정보 추가
    @PostMapping
    public ResponseEntity<ApiResponse<CartViewDTO>> addCartItem(@RequestBody CartEntity cart, HttpSession session) {
    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 			  .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
        }

        cart.setMemberId(loginMember.getMemberId());
        CartViewDTO cartViewDTO = myCartService.saveCartItemAndGetView(cart);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, cartViewDTO));
    }

    // 장바구니 항목 수량 수정
    @PutMapping
    public ResponseEntity<ApiResponse<String>> updateCartItem(@RequestBody CartEntity cart) {
    	myCartService.updateForProductCnt(cart);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "수량 수정 완료"));
    }

    // 장바구니 항목 단건 삭제
    @DeleteMapping("/delete/{cartId}")
    public ResponseEntity<ApiResponse<String>> deleteCartItem(@PathVariable int cartId) {
    	myCartService.deleteByCartId(cartId);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "장바구니 항목 삭제 완료"));
    }

    // 장바구니 전체 삭제
    @DeleteMapping("/deleteAll")
    public ResponseEntity<ApiResponse<String>> deleteAll(HttpSession session) {
    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 			  .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
        }
    	myCartService.deleteByMemberId(loginMember.getMemberId());
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "장바구니 전체 삭제 완료"));
    }
}
