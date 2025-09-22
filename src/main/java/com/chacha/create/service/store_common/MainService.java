package com.chacha.create.service.store_common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.product.HomeDTO;
import com.chacha.create.common.dto.product.HomeProductDTO;
import com.chacha.create.common.dto.store.StoreCategoryDTO;
import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;
import com.chacha.create.common.mapper.category.DCategoryMapper;
import com.chacha.create.common.mapper.category.TypeCategoryMapper;
import com.chacha.create.common.mapper.category.UCategoryMapper;
import com.chacha.create.common.mapper.product.MainPageMapper;
import com.chacha.create.common.mapper.product.ProductMapper;
import com.chacha.create.common.mapper.store.StoreIdCheckMapper;
import com.chacha.create.util.ServiceUtil;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MainService {

    private final MainPageMapper mainPageMapper;
    private final StoreIdCheckMapper idCheckMapper;
    private final ProductMapper productMapper;
    private final UCategoryMapper uCategoryMapper;
    private final DCategoryMapper dCategoryMapper;
    private final TypeCategoryMapper typeCategoryMapper;
    private final S3Uploader s3Uploader;
    
    /** 🛍️ 스토어 메인 페이지 - 인기 + 대표 상품 묶음 */
    public Map<String, List<HomeProductDTO>> getStoreMainProductMap(int storeId) {
        return Map.of(
            "bestProduct", mainPageMapper.selectForBestProduct(storeId),
            "mainProduct", mainPageMapper.selectForStoreMainProduct(storeId)
        );
    }

    /** 🏠 메인 홈 - 인기 스토어 + 인기 상품 + 신상품 */
    public Map<String, Object> getHomeMainProductMap() {
    	List<HomeDTO> bestStore = mainPageMapper.selectForBestStore();
    	bestStore.forEach(s->s.setLogoImg(s3Uploader.getThumbnailUrlByFullUrl(s.getLogoImg())));
        return Map.of(
            "bestStore", bestStore,
            "bestProduct", mainPageMapper.selectForBestProduct(null),
            "newProduct", mainPageMapper.selectForNewProduct()
        );
    }

    /** 🔍 필터/검색 조건 기반 상품 리스트 조회 */
    public List<HomeProductDTO> getFilteredProductListWithParams(
            Integer storeId,
            List<String> type,
            List<String> d,
            List<String> u,
            String keyword,
            String sort) {

    		// mybatis 쿼리에 전달할 파라미터 map
        Map<String, Object> params = new HashMap<>();
        if (storeId != null) params.put("storeId", storeId);
        params.put("sort", (sort != null && !sort.isEmpty()) ? sort : "latest");
        params.put("keyword", keyword);

        // 문자열 ID 리스트를 mybatis에서 사용할 수 있도록 파싱 및 추가
        ServiceUtil.putParsedParam(params, "type", type);
        ServiceUtil.putParsedParam(params, "d", d);
        ServiceUtil.putParsedParam(params, "u", u);

        // 키워드가 존재하면 전용 쿼리 실행
        if (keyword != null && !keyword.isEmpty()) {
            log.info("🔍 상품명 검색 요청: {}", keyword);
            return mainPageMapper.selectByProductName(keyword);
        }

        log.info("🔍 조건 기반 상품 조회 요청: {}", params);
        return mainPageMapper.selectForProductList(params);
    }

    /** 📌 스토어 URL → 스토어 ID 확인 */
    public int storeIdCheck(String storeUrl) {
        return idCheckMapper.selectByStoreUrl(storeUrl);
    }
    
    /** 전체 카테고리 조회 : type + ucategory*/
    public Map<String, Object> getAllCategory(){
    			return Map.of(
    					"typeCategory",List.of(TypeCategoryEnum.values()),
    					"uCategory",List.of(UCategoryEnum.values())
    					);
    }
    
    /** UCategory에 해당하는 DCategory 조회 (id + name 반환) */
    public List<Map<String, Object>> getDCategoryByUCategoryName(String uCategoryName) {
        try {
        		// 문자열을 Enum으로 반환
            UCategoryEnum uCategory = UCategoryEnum.fromName(uCategoryName);

            // 해당 ucategory에 매핑도니 dcategory 리스트 조회
            return DCategoryEnum.getByUCategory(uCategory).stream()
                .map(d -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", d.getId());      			// dcategory ID
                    map.put("name", d.getName());  	// dcategory 이름
                    return map;
                })
                .collect(Collectors.toList());

        } catch (IllegalArgumentException e) {
            return List.of(); // 유효하지 않은 경우 빈 리스트 반환
        }
    }

	public int click(int productId) {
		return productMapper.updateClick(productId);
	}
	
	public StoreCategoryDTO getStoreCategories(int storeId) {
		Map<String, Object> topCategories = typeCategoryMapper.selectTopStoreCategories(storeId);
		String up   = (String) topCategories.get("UP_CATEGORY");
		String down = (String) topCategories.get("DOWN_CATEGORY");
		String type = (String) topCategories.get("TYPE_CATEGORY");
		
        return StoreCategoryDTO.builder()
                .uCategory(up)
                .dCategory(down)
                .typeCategory(type)
                .build();
	}

}
