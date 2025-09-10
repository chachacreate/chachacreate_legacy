package com.chacha.create.service.seller.settlement;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.product.ProductDailySettlementDTO;
import com.chacha.create.common.dto.product.ProductSalesResponseDTO;
import com.chacha.create.common.dto.product.StoreProductSettlementDTO;
import com.chacha.create.common.mapper.manage.ManageMapper;
import com.chacha.create.common.mapper.product.ProductMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SettlementManagementService {
	
	private final ManageMapper manageMapper;
	private final ProductMapper productMapper;
	
	public List<Map<String, Object>> sellerSettlementManagement(String storeUrl){
		return manageMapper.sellerSettlementManagement(storeUrl);
	}
	
	public Map<String, List<Map<String, Object>>>  sellerDaySellManagement(String storeUrl){
		
		List<Map<String, Object>> result = manageMapper.sellerDaySellManagement(storeUrl);
        Map<String, List<Map<String, Object>>> grouped = new java.util.LinkedHashMap<>();

        for (Map<String, Object> row : result) {
            String productName = (String) row.get("PRODUCT_NAME");
            if (!grouped.containsKey(productName)) {
                grouped.put(productName, new java.util.ArrayList<>());
            }
            Map<String, Object> daily = new java.util.HashMap<>();
            daily.put("SALEDATE", row.get("SALEDATE"));
            daily.put("DAILYTOTAL", row.get("DAILYTOTAL"));
            grouped.get(productName).add(daily);
        }
        return grouped;
	}
	
	/**
     * 특정 상품의 일별 정산 데이터 조회
     */
	public ProductDailySettlementDTO getProductDailySettlement(Integer productId) {
	    // 이제 DailyEntry 리스트를 반환받음
	    List<ProductDailySettlementDTO.DailyEntry> rows =
	            productMapper.selectProductDailyAmounts(productId);

	    return ProductDailySettlementDTO.builder()
	            .productId(productId)
	            .daily(rows)
	            .build();
	}
	
	/** 스토어 전체 상품 정산 */
    public List<StoreProductSettlementDTO> getStoreProductSettlements(String storeUrl) {
        return productMapper.selectStoreProductSettlements(storeUrl);
    }

    // 판매자 상품 매출 조회
    public List<ProductSalesResponseDTO> getDailyProductSalesByStore(String storeUrl) {
        return productMapper.findDailyProductSalesByStore(storeUrl);
    }


}
