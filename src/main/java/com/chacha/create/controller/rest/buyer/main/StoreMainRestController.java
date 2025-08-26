package com.chacha.create.controller.rest.buyer.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.HomeProductDTO;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.MainService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}")
public class StoreMainRestController {

    @Autowired
    private MainService mainService;

    //스토어 대표 상품, 인기 상품 조회
    @GetMapping
    public ResponseEntity<ApiResponse<Map<String, List<HomeProductDTO>>>> getStoreMainProducts(
            @PathVariable String storeUrl,
            @RequestParam(value = "storeId", required = false) String storeIdParam) {

        log.info("스토어 메인 페이지 접근 : storeUrl={}, storeIdParam={}", storeUrl, storeIdParam);
        int storeId;

        if (storeIdParam != null) {
            storeId = Integer.parseInt(storeIdParam);				// 전달된 storeId를 정수로 파싱
        } else {
            storeId = mainService.storeIdCheck(storeUrl);			// 없으면 storeUrl로 storeId 조회
        }
        log.info("조회 대상 스토어 ID: {}", storeId);
        
        // 대표상품, 인기상품 map으로 반환
        Map<String, List<HomeProductDTO>> result = mainService.getStoreMainProductMap(storeId);
        
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }

    // 스토어 전체상품 조회(조건조회)
    @GetMapping("/products")
    public ResponseEntity<ApiResponse<List<HomeProductDTO>>> getProductList(
    			@PathVariable String storeUrl,
            @RequestParam(required = false) Integer storeId,
            @RequestParam(required = false) List<String> type,
            @RequestParam(required = false) List<String> d,
            @RequestParam(required = false) List<String> u,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(required = false, defaultValue = "latest") String sort) {
    		
    		if(storeId == null  || storeId == 0) {
    			storeId = mainService.storeIdCheck(storeUrl);
    		}
    		
    		// 프론트에서 넘어온 String ID들을 Integer로 파싱
    		Map<String, List<Integer>> parsedMap = new HashMap<>();
    		if(type != null && !type.isEmpty()) {
    			parsedMap.put("type", type.stream().map(Integer::parseInt).collect(Collectors.toList()));
    		}
    		if(u != null && !u.isEmpty()) {
    			parsedMap.put("u", u.stream().map(Integer::parseInt).collect(Collectors.toList()));
    		}
    		if(d != null && !d.isEmpty()) {
    			parsedMap.put("d", d.stream().map(Integer::parseInt).collect(Collectors.toList()));
    		}

        List<HomeProductDTO> result = mainService.getFilteredProductListWithParams(
                storeId, type, d, u, keyword, sort);
        
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }
    
    // 존재하는 카테고리 조회 (ucategory 이름으로 dcategory 조회)
    @GetMapping("/categories")
    public ResponseEntity<?> getAllCategories(@RequestParam(required = false) String uCategoryName) {

    		// ucategoryName 없으면 전체 type/ucategory 조회
        if (uCategoryName == null) {
            Map<String, Object> raw = mainService.getAllCategory();		// enum 기반 카테고리 반환

            // typecategoryEnum -> json 형식으로 반환
            List<Map<String, Object>> typeList = ((List<TypeCategoryEnum>) raw.get("typeCategory")).stream()
                    .map(t -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("id", t.getId());
                        map.put("name", t.getName());
                        return map;
                    })
                    .collect(Collectors.toList());

         // ucategoryEnum → json 형식으로 반환
            List<Map<String, Object>> uList = ((List<UCategoryEnum>) raw.get("uCategory")).stream()
                    .map(u -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("id", u.getId());
                        map.put("name", u.getName());
                        return map;
                    })
                    .collect(Collectors.toList());

            	// 결과 map 생성
            Map<String, Object> result = Map.of(
                    "typeCategory", typeList,
                    "uCategory", uList
            );

            return ResponseEntity.ok(result);
        } else {
        	// ucategory 이름이 들어왔을 경우, 해당 ucategory에 속한 dcategory 조회
        	List<Map<String, Object>> dCategoryList = mainService.getDCategoryByUCategoryName(uCategoryName);
            return ResponseEntity.ok(dCategoryList);
        }
    }

}
    
    
    
