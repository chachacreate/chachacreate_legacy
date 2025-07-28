package com.chacha.create.common.mapper.product;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.product.PImgEntity;

/**
 * {@code p_img} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 상품 이미지(p_img)의 등록, 조회, 수정, 삭제 기능을 제공합니다.
 */
@Mapper
public interface PImgMapper {

    /**
     * 모든 상품 이미지 정보를 조회합니다.
     *
     * @return {@code List<PImgEntity>} 전체 이미지 목록
     */
    List<PImgEntity> selectAll();

    /**
     * 이미지 ID로 단일 상품 이미지를 조회합니다.
     *
     * @param pImgId 이미지 ID
     * @return 해당 이미지 ID의 {@code PImgEntity} 객체
     */
    PImgEntity selectByPImgId(int pimgId);

    /**
     * 상품 ID로 해당 상품의 모든 이미지를 조회합니다.
     *
     * @param productId 상품 ID
     * @return 해당 상품에 속한 이미지 목록 ({@code List<PImgEntity>})
     */
    List<PImgEntity> selectByProductId(int productId);

    /**
     * 새로운 상품 이미지를 등록합니다.
     * 이미지 ID는 Oracle 시퀀스 {@code seq_p_img_id.NEXTVAL}로 자동 생성됩니다.
     *
     * @param pImgEntity 삽입할 이미지 정보
     * @return 영향 받은 행 수
     */
    int insert(PImgEntity pImgEntity);

    /**
     * 기존 상품 이미지 정보를 수정합니다.
     *
     * @param pImgEntity 수정할 이미지 정보
     * @return 영향 받은 행 수
     */
    int update(PImgEntity pImgEntity);

    /**
     * 이미지 ID를 기반으로 이미지를 삭제합니다.
     *
     * @param pImgId 삭제할 이미지 ID
     * @return 영향 받은 행 수
     */
    int delete(int pimgId);

	void deleteImagesByProductId(int productId);
}