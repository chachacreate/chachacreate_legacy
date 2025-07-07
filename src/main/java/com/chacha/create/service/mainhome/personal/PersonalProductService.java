package com.chacha.create.service.mainhome.personal;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.product.PersonalProductDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.category.DCategoryMapper;
import com.chacha.create.common.mapper.category.TypeCategoryMapper;
import com.chacha.create.common.mapper.category.UCategoryMapper;
import com.chacha.create.common.mapper.product.PersonalProductMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class PersonalProductService {

    private final PersonalProductMapper personalProductMapper;
    private final TypeCategoryMapper typeCategoryMapper;
    private final DCategoryMapper dCategoryMapper;

    @Transactional(rollbackFor = Exception.class)
    public int insertOrUpdateProductImages(PersonalProductDTO dto, boolean isInsert) {
    	int result = 0;
    	if(dto.getPimgUrl1() != null) {
            if (isInsert) {
                result += personalProductMapper.insertMainProductImage(dto.getProductId(), 1, dto.getPimgUrl1());
            } else {
                result += personalProductMapper.updateMainProductImage(dto.getProductId(), 1, dto.getPimgUrl1());
            }	
    	}
    	if(dto.getPimgUrl2() != null) {
            if (isInsert) {
                result += personalProductMapper.insertMainProductImage(dto.getProductId(), 2, dto.getPimgUrl2());
            } else {
                result += personalProductMapper.updateMainProductImage(dto.getProductId(), 2, dto.getPimgUrl2());
            }	
    	}
    	if(dto.getPimgUrl3() != null) {
            if (isInsert) {
                result += personalProductMapper.insertMainProductImage(dto.getProductId(), 3, dto.getPimgUrl3());
            } else {
                result += personalProductMapper.updateMainProductImage(dto.getProductId(), 3, dto.getPimgUrl3());
            }	
    	}
    	
        return result;
    }
    
    @Transactional(rollbackFor = Exception.class)
    public int insertMainProductWithImages(PersonalProductDTO dto, MemberEntity member) {
    	if(member == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	log.info(personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId()).toString());
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());
        dto.setSellerId(((BigDecimal)idMap.get("SELLER_ID")).intValue());
        dto.setStoreId(((BigDecimal)idMap.get("STORE_ID")).intValue());
        
        log.info(dto.toString());
        
        int result1 = personalProductMapper.insertMainProduct(dto);
        result1 += insertOrUpdateProductImages(dto, true);

        return (result1 > 1) ? 1 : 0;
    }

    public List<PersonalProductDTO> getProductsByMemberId(MemberEntity member) {
    	if(member == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	log.info(personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId()).toString());
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());

        return personalProductMapper.selectProductsByStoreId(((BigDecimal)idMap.get("STORE_ID")).intValue());
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateMainProductWithImages(PersonalProductDTO dto, MemberEntity member) {
    	if(member == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	log.info(personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId()).toString());
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());
        dto.setSellerId(((BigDecimal)idMap.get("SELLER_ID")).intValue());
        dto.setStoreId(((BigDecimal)idMap.get("STORE_ID")).intValue());

        log.info("상품 수정 요청 - productId: {}, sellerId: {}, storeId: {}", 
            dto.getProductId(), idMap.get("sellerId"), idMap.get("storeId"));

        int result1 = personalProductMapper.updateMainProduct(dto);
        int result2 = insertOrUpdateProductImages(dto, false);

        if (result1 > 0 || result2 > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteMainProduct(int productId, MemberEntity member) {
    	if(member == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());
        int sellerId = ((BigDecimal)idMap.get("SELLER_ID")).intValue();
        int storeId = ((BigDecimal)idMap.get("STORE_ID")).intValue();
        
        int belongs = personalProductMapper.checkProductBelongsToSellerStore(productId, sellerId, storeId);
        if (belongs == 0) {
            log.warn("상품이 sellerId/storeId에 속하지 않음. 삭제 권한 없음.");
            return -2;
        }

        int result = personalProductMapper.deleteMainProductById(productId);
        if (result > 0) {
            log.info("상품 ID {} 삭제 성공", productId);
            return 1;
        } else {
            log.warn("상품 ID {} 삭제 실패 또는 존재하지 않음", productId);
            return 0;
        }
    }
    
    public Map<String, Object> categoryList(){
    	Map<String, Object> categoryMap = new HashMap<String, Object>();
	    	categoryMap.put("typeCategory", typeCategoryMapper.selectAll());
	    	categoryMap.put("dCategoryMapper", dCategoryMapper.selectAll());
    	return categoryMap;
    }
}