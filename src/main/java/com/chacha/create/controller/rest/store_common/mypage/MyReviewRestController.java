package com.chacha.create.controller.rest.store_common.mypage;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.ReviewEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.detail.ReviewService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/main/mypage")
public class MyReviewRestController {

    @Autowired
    private ReviewService reviewService;
    
    // 리뷰 ID로 조회 (GET 방식) - 단건 조회
    @GetMapping("/reviewById")
    public ResponseEntity<ApiResponse<ReviewEntity>> getReviewById(@RequestParam int reviewId) {
        ReviewEntity review = reviewService.selectByReviewId(reviewId);
        if (review == null) {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.NOT_FOUND, null));
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, review));
    }
    
    // 회원 ID로 조회 - 내 리뷰 전체 조회
    @GetMapping("/reviewmemberById")
    public ResponseEntity<ApiResponse<List<ReviewEntity>>> getReviewsByMemberId(HttpSession session) {
        MemberEntity member = (MemberEntity) session.getAttribute("loginMember");
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
        }

        List<ReviewEntity> reviews = reviewService.selectByMemberId(member.getMemberId());
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, reviews));
    }
     
}