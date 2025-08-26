package com.chacha.create.controller.rest.buyer.detail;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.ReviewEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.detail.ReviewService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}/productdetail/{productId}/review")
public class ProductReviewRestController {

	@Autowired
	private ReviewService reviewService;

	// 리뷰 작성 가능 여부를 체크하는 함수(프론트 연결 시 필요)
	@GetMapping("/check")
	public ResponseEntity<ApiResponse<Boolean>> isReviewWritable(@RequestParam int orderDetailId, HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		if (loginMember == null) {
			return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
					.body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, false));
		}
		boolean writable = reviewService.selectForCheckReview(orderDetailId, loginMember.getMemberId());
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, writable));
	}

	// 주문 상세별 자신의 리뷰 조회(수정 및 삭제 시 리뷰 불러오는 용도)
	@GetMapping("/orderdetail/{orderDetailId}")
	public ResponseEntity<ApiResponse<ReviewEntity>> getReviewByOrderDetail(@PathVariable int orderDetailId) {
		ReviewEntity review = reviewService.selectByOrderDetailId(orderDetailId);
		if (review == null) {
			return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
					.body(new ApiResponse<>(ResponseCode.NOT_FOUND, null));
		}
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, review));
	}
	
	// 상품별 리뷰 조회(자신의 리뷰가 먼저 보이도록)
	@GetMapping
	public ResponseEntity<ApiResponse<List<ReviewEntity>>> getReviewsByProduct(@PathVariable int productId,
																																HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
	    Integer memberId = (loginMember != null) ? loginMember.getMemberId() : null;
		
		List<ReviewEntity> reviews = reviewService.selectByProductId(productId, memberId);
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, reviews));
	}

	@PostMapping
	public ResponseEntity<ApiResponse<Integer>> addReview(@RequestBody ReviewEntity review, HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		int result = reviewService.insert(review, loginMember);
		ResponseCode responseCode = result > 0 ? ResponseCode.CREATED : ResponseCode.BAD_REQUEST;
		return ResponseEntity.status(responseCode.getStatus()).body(new ApiResponse<>(responseCode, result));
	}

	@PutMapping
	public ResponseEntity<ApiResponse<Integer>> updateReview(@RequestBody ReviewEntity review, HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		int result = reviewService.update(review, loginMember);
		ResponseCode responseCode = result > 0 ? ResponseCode.OK : ResponseCode.BAD_REQUEST;
		return ResponseEntity.status(responseCode.getStatus()).body(new ApiResponse<>(responseCode, result));
	}

	@DeleteMapping
    public ResponseEntity<ApiResponse<Integer>> deleteReview(@RequestParam int reviewId, HttpSession session) {
        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        int result = reviewService.delete(reviewId, loginMember);
        ResponseCode responseCode = result > 0 ? ResponseCode.OK : ResponseCode.BAD_REQUEST;
        return ResponseEntity.status(responseCode.getStatus())
                .body(new ApiResponse<>(responseCode, result));
    }
}