package com.chacha.create.common.mapper.order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.dto.product.ReviewManagementDTO;
import com.chacha.create.common.entity.order.ReviewEntity;

/**
 * {@code review} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 리뷰 등록, 조회, 수정, 삭제 기능을 제공합니다.
 */
@Mapper
public interface ReviewMapper {

    // 전체 리뷰 목록 조회
    List<ReviewEntity> selectAll();

    // 리뷰ID를 통한 단일 리뷰 조회
    ReviewEntity selectByReviewId(int reviewId);
    
    // 회원ID를 통한 회원의 전체 리뷰 조회
    List<ReviewEntity> selectByMemberId(int memberId);

    /**
     * 주문 상세 ID로 리뷰를 조회합니다.
     * 하나의 주문 상세(order_detail)에 하나의 리뷰만 작성된다는 전제가 필요합니다.
     *
     * @param orderDetailId 주문 상세 ID
     * @return 해당 주문 상세에 대한 리뷰 객체
     */
    ReviewEntity selectByOrderDetailId(int orderDetailId);
    
    // 특정 상품에 대한 리뷰 전체 조회 + 내 리뷰 우선
    List<ReviewEntity> selectByProductId(@Param("productId") int productId,
                                         @Param("memberId") Integer memberId);

    // 본인이 해당 주문 상세에 대해 리뷰 작성 가능한지 여부
    int selectForCheckReview(@Param("orderDetailId") int orderDetailId,
                      @Param("memberId") int memberId);
    
    /**
     * 새로운 리뷰를 삽입합니다.
     * 리뷰 ID는 시퀀스(seq_review_id.NEXTVAL)로 생성됩니다.
     *
     * @param reviewEntity 추가할 리뷰 객체
     * @return 삽입된 행 수
     */
    int insert(ReviewEntity reviewEntity);

    /**
     * 기존 리뷰 정보를 수정합니다.
     *
     * @param reviewEntity 수정할 리뷰 객체
     * @return 수정된 행 수
     */
    int update(@Param("review") ReviewEntity review,
    				 @Param("memberId") int memberId);


    /**
     * 리뷰 ID로 리뷰를 삭제합니다.
     *
     * @param reviewId 삭제할 리뷰 ID
     * @return 삭제된 행 수
     */
    int delete(@Param("reviewId") int reviewId,
               		@Param("memberId") int memberId);

    // 판매자 기준 내 상품의 리뷰 모아 보기
    List<Map<String, Object>> selectByStoreUrl(String storeUrl);
    
    List<ReviewManagementDTO> selectAllmyReview(@Param("storeUrl") String storeUrl);
    
    // 신고를 위해 리뷰 작성자 조회
    int selectForMemberIdByReviewId(int reviewId);
}
