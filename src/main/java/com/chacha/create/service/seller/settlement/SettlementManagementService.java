package com.chacha.create.service.seller.settlement;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chacha.create.common.mapper.manage.ManageMapper;
import com.chacha.create.common.mapper.product.PImgMapper;
import com.chacha.create.common.mapper.product.ProductManageMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SettlementManagementService {
	
	private final ManageMapper manageMapper;
	
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
}
