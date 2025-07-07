package com.chacha.create.service.buyer.detail;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.product.ReviewManagementDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.OrderDetailEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.entity.order.ReviewEntity;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.order.OrderDetailMapper;
import com.chacha.create.common.mapper.order.OrderInfoMapper;
import com.chacha.create.common.mapper.order.ReviewMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ReviewService {
	
    private final ReviewMapper reviewMapper;
	private final OrderDetailMapper orderDetailMapper;
	private final OrderInfoMapper orderInfoMapper;

    // 전체 리뷰 조회(메인홈 관리자용)
    public List<ReviewEntity> selectAll() {
        return reviewMapper.selectAll();
    }

    // 리뷰 상세 조회
    public ReviewEntity selectByReviewId(int reviewId) {
        return reviewMapper.selectByReviewId(reviewId);
    }

    // 회원별 리뷰 조회
    public List<ReviewEntity> selectByMemberId(int memberId) {
        return reviewMapper.selectByMemberId(memberId);
    }
    
    // 주문 상세별 리뷰 검증(이미 있을 경우 작성 불가)
    public boolean selectForCheckReview(int orderDetailId, int memberId) {
        return reviewMapper.selectForCheckReview(orderDetailId, memberId) > 0;
    }

    // 주문 상세별 리뷰 조회
    public ReviewEntity selectByOrderDetailId(int orderDetailId) {
        return reviewMapper.selectByOrderDetailId(orderDetailId);
    }

    // 상품별 리뷰 조회(로그인했을 경우 자신의 리뷰가 먼저 보이게)
    public List<ReviewEntity> selectByProductId(int productId, Integer memberId) {
        return reviewMapper.selectByProductId(productId, memberId);
    }
    
    // 판매자가 리뷰 신고를 할 때 리뷰 작성자 멤버 ID 조회
    public int selectForMemberIdByReviewId(int reviewId) {
    	return reviewMapper.selectForMemberIdByReviewId(reviewId);
    }

    // 리뷰 등록
    @Transactional(rollbackFor = Exception.class)
    public int insert(ReviewEntity review, MemberEntity loginMember) {
    	if(loginMember == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	int loginMemberId = loginMember.getMemberId();
        // 조건 1) 주문 내역이 없을 경우 리뷰 작성 불가
        Integer orderDetailId = review.getOrderDetailId();
        if (orderDetailId == null) {
            throw new IllegalArgumentException("주문 내역 없을 경우 리뷰 작성 불가");
        }

        // 조건 2) 주문 상세의 회원 ID(구매자)와 로그인 회원 일치 확인
        OrderDetailEntity orderDetail = orderDetailMapper.selectByOrderDetailId(orderDetailId);
        int orderId = orderDetail.getOrderId();
        OrderInfoEntity orderInfo = orderInfoMapper.selectByOrderId(orderId);
        if (orderInfo.getMemberId() != loginMemberId) {
        	throw new IllegalArgumentException("본인의 주문에 대해서만 리뷰 작성 가능");
        }

        // 현재 날짜로 세팅
        review.setReviewDate(new java.sql.Date(System.currentTimeMillis()));
        return reviewMapper.insert(review);
    }

    // 리뷰 수정
    @Transactional(rollbackFor = Exception.class)
    public int update(ReviewEntity review, MemberEntity loginMember) {
    	if(loginMember == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	int loginMemberId = loginMember.getMemberId();
    	// 현재 날짜로 세팅
    	review.setReviewDate(new java.sql.Date(System.currentTimeMillis()));
        return reviewMapper.update(review, loginMemberId);
    }

    // 리뷰 삭제
    @Transactional(rollbackFor = Exception.class)
    public int delete(int reviewId, MemberEntity loginMember) {
    	if(loginMember == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	int loginMemberId = loginMember.getMemberId();
        return reviewMapper.delete(reviewId, loginMemberId);
    }

    // 판매자별 리뷰 조회
    public List<Map<String, Object>> selectByStoreUrl(String storeUrl) {
        return reviewMapper.selectByStoreUrl(storeUrl);
    }
    
    // 판매자 기준 리뷰 목록 (썸네일, 상품명, 작성자 포함)
    public List<ReviewManagementDTO> selectAllMyReview(String storeUrl) {
        return reviewMapper.selectAllmyReview(storeUrl);
    }
}