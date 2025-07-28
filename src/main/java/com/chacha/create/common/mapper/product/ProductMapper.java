package com.chacha.create.common.mapper.product;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.product.ProductEntity;

/**
 * {@code product} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 상품 등록, 조회, 수정, 삭제 기능을 제공합니다.
 */
@Mapper
public interface ProductMapper {

    /**
     * 모든 상품 목록을 조회합니다.
     *
     * @return {@code List<ProductEntity>} 전체 상품 목록
     */
    List<ProductEntity> selectAll();

    /**
     * 상품 ID로 상품을 조회합니다.
     *
     * @param productId 상품 ID
     * @return {@code ProductEntity} 상품 객체
     */
    ProductEntity selectByProductId(int productId);

    /**
     * 스토어 ID로 상품 목록을 조회합니다.
     *
     * @param storeId 스토어 ID
     * @return {@code List<ProductEntity>} 해당 스토어의 상품 목록
     */
    List<ProductEntity> selectByStoreId(int storeId);

    /**
     * 새로운 상품을 등록합니다.
     * 상품 ID는 Oracle 시퀀스 {@code seq_product_id.NEXTVAL}로 자동 생성됩니다.
     *
     * @param productEntity 등록할 상품 객체
     * @return 영향 받은 행 수
     */
    int insert(ProductEntity productEntity);

    /**
     * 기존 상품 정보를 수정합니다.
     *
     * @param productEntity 수정할 상품 객체
     * @return 영향 받은 행 수
     */
    int update(ProductEntity productEntity);

    /**
     * 상품 ID로 상품을 삭제합니다.
     *
     * @param productId 삭제할 상품의 ID
     * @return 영향 받은 행 수
     */
    int delete(int productId);

	int selectForStoreIdByStoreUrl(String storeUrl);
	
	// for 자신의 상품인지 검증
	int selectForStoreIdByProductId(int productId);
}
