package com.chacha.create.common.mapper.product;

import java.util.List;
import java.util.Map;

import com.chacha.create.common.dto.product.HomeDTO;
import com.chacha.create.common.dto.product.HomeProductDTO;

public interface MainPageMapper {
	// 공통 부분
	// 메인페이지 전체 상품 조회
    List<HomeProductDTO> selectForProductList(Map<String, Object> params);
	// 상품명으로 검색시 해당 상품 조회 
    List<HomeProductDTO> selectByProductName(String keyword);
    // 메인페이지에서 인기 상품 조회
    List<HomeProductDTO> selectForBestProduct(Integer storeId);
    
    // 스토어
    // 스토어 대표상품 조회
 	List<HomeProductDTO> selectForStoreMainProduct(Integer storeId);
    
    // 메인 홈
    // 메인페이지에서 인기 스토어 조회
    List<HomeDTO> selectForBestStore();
    // 메인페이지에서 최신 상품 조회
    List<HomeProductDTO> selectForNewProduct();
}
