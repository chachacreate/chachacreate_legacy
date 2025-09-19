package com.chacha.create.common.mapper.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.entity.member.SellerEntity;

/**
 * seller 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface SellerMapper {

    /**
     * 모든 판매자 정보를 조회합니다.
     *
     * @return 판매자 엔티티 리스트
     */
    List<SellerEntity> selectAll();

    /**
     * sellerId로 특정 판매자 정보를 조회합니다.
     *
     * @param sellerId 조회할 판매자 ID
     * @return 조회된 SellerEntity 객체 (없으면 null)
     */
    SellerEntity selectBySellerId(int sellerId);

    /**
     * memberId로 특정 판매자 정보를 조회합니다.
     *
     * @param memberId 조회할 회원 ID
     * @return 조회된 SellerEntity 객체 (없으면 null)
     */
    SellerEntity selectByMemberId(int memberId);

    /**
     * 새로운 판매자 정보를 삽입합니다.
     * seq_seller_id 시퀀스를 사용하여 seller_id가 자동 생성됩니다.
     *
     * @param seller 삽입할 SellerEntity 객체
     * @return 삽입 성공 시 영향 받은 행 수
     */
    int insert(SellerEntity seller);

    /**
     * 기존 판매자 정보를 수정합니다.
     *
     * @param seller 수정할 SellerEntity 객체
     * @return 수정 성공 시 영향 받은 행 수
     */
    int update(SellerEntity seller);

    /**
     * sellerId로 판매자 정보를 삭제합니다.
     *
     * @param sellerId 삭제할 판매자 ID
     * @return 삭제 성공 시 영향 받은 행 수
     */
    int delete(int sellerId);
    
    int updateSellerInfo(SellerEntity seller);
    
    int updateBypersonalCheck(@Param("sellerId") int sellerId, @Param("personalCheck") int personalCheck);

    /**
     * 주어진 판매자 ID(sellerId)에 매핑된 회원 ID(memberId)를 조회합니다.
     *
     * @param sellerId 판매자 ID
     * @return 해당 판매자의 회원 ID
     */
    int selectMemberIdForSellerId(@Param("sellerId") int sellerId);

    // seller_id로 profile_info 조회
    /**
     * 판매자 프로필 정보(profile_info)를 조회합니다.
     *
     * @param sellerId 판매자 ID
     * @return 프로필 소개 문자열(없으면 null)
     */
    String selectProfileInfoBySellerId(@Param("sellerId") int sellerId);

    
}
