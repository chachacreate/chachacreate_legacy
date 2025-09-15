package com.chacha.create.controller.rest.mainhome.main;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.HomeProductDTO;
import com.chacha.create.common.dto.store.StoreCategoryDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.MainService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping(value = "/legacy", method = RequestMethod.GET)
public class HomeMainRestController {
	
	@Autowired
	MainService mainService;
	
	// 메인 홈 메인페이지에서 인기스토어,인기상품,최신상품조회
    @GetMapping("/main")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getProductList() {
        Map<String, Object> result = mainService.getHomeMainProductMap();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }

	// 메인홈 전체상품 조회(조건조회)
	@GetMapping("/main/products")
    public ResponseEntity<ApiResponse<List<HomeProductDTO>>> getProductList(
            @RequestParam(required = false) List<String> type,
            @RequestParam(required = false) List<String> d,
            @RequestParam(required = false) List<String> u,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(required = false, defaultValue = "latest") String sort) {
        List<HomeProductDTO> result = mainService.getFilteredProductListWithParams(
                null, type, d, u, keyword, sort);

        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }
	
    @GetMapping("/click/{productId}")
    public ResponseEntity<ApiResponse<String>> clickStore(
    		@PathVariable int productId
    		){
    	mainService.click(productId);
    	return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "성공"));
    }
    
    @GetMapping("/main/{storeId}/categories")
    public ResponseEntity<ApiResponse<StoreCategoryDTO>> getStoreCategories(@PathVariable int storeId) {
    	StoreCategoryDTO result = mainService.getStoreCategories(storeId);
    	return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }
		
}
