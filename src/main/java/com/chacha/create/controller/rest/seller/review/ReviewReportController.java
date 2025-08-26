package com.chacha.create.controller.rest.seller.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.detail.ReviewService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}/seller")
public class ReviewReportController {

	@Autowired
	private ReviewService reviewService;
	
	// 리뷰 ID로 멤버 ID 조회
    @GetMapping("/review/member/{reviewId}")
    public ResponseEntity<?> getMemberIdByReviewId(@PathVariable int reviewId) {
        int memberId = reviewService.selectForMemberIdByReviewId(reviewId);

        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "회원 조회 성공", memberId));
    }
}
