package com.chacha.create.controller.rest.seller.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.ReviewManagementDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.detail.ReviewService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/legacy/{storeUrl}/seller")
@Slf4j
public class ReviewManagementController {

	@Autowired
	private ReviewService reviewService;

	@GetMapping(value = "/reviews", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<List<ReviewManagementDTO>>> getReviewList(
			@PathVariable("storeUrl") String storeUrl) {
		log.info("리뷰 목록 조회 요청 - storeUrl: {}", storeUrl);
		List<ReviewManagementDTO> reviews = reviewService.selectAllMyReview(storeUrl);

		if (reviews == null || reviews.isEmpty()) {
			return ResponseEntity.status(ResponseCode.NO_CONTENT.getStatus())
					.body(new ApiResponse<>(ResponseCode.NO_CONTENT, "리뷰가 존재하지 않습니다.", reviews));
		}

		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "리뷰 목록 조회 성공", reviews));
	}
}