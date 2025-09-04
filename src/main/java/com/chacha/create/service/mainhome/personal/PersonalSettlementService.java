package com.chacha.create.service.mainhome.personal;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.mapper.manage.ManageMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class PersonalSettlementService {

    private final ManageMapper manageMapper;

    public List<Map<String, Object>> sellManagement(MemberEntity loginMember) {
    	List<Map<String, Object>> manage = manageMapper.sellManagement(loginMember.getMemberId()); //이거 member 이름 넣어야함
    	manage.stream().forEach(map -> {
    		map.put("sellerName", loginMember.getMemberName());
    		map.put("accountHolder", loginMember.getMemberName());
    	});
    	
        return manageMapper.sellManagement(loginMember.getMemberId());
    }

    public Map<String, List<Map<String, Object>>> daySellManagementByProduct(MemberEntity loginMember) {

        List<Map<String, Object>> result = manageMapper.daySellManagementByProduct(loginMember.getMemberId());
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