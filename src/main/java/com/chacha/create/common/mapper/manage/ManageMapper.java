package com.chacha.create.common.mapper.manage;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.dto.manager.ManagerAdjustmentDTO;
import com.chacha.create.common.dto.member.SellerInfoDTO;

@Mapper
public interface ManageMapper {
    List<SellerInfoDTO> selectBySellerInfo(String storeUrl);

    List<ManagerAdjustmentDTO> sellerAdjustment(); 
    
    List<ManagerAdjustmentDTO> storeAdjustment();
    
    List<Map<String, Object>> sellManagement(int member_id);

    List<Map<String, Object>> daySellManagementByProduct(int member_id);
    
    List<Map<String, Object>> sellerDaySellManagement(String storeUrl);
    
    List<Map<String, Object>> sellerSettlementManagement(String storeUrl);
}
