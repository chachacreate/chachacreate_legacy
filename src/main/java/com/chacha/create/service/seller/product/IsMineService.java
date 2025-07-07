package com.chacha.create.service.seller.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.product.ProductMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class IsMineService {
	
	@Autowired
	ProductMapper productMapper;
	
	@Autowired
	StoreMapper storeMapper;
	
	@Autowired
	SellerMapper sellerMapper;
	
	public boolean isEditableByMember(int productId, int loginMemberId) {
	    int storeId = productMapper.selectForStoreIdByProductId(productId);
	    int sellerId = storeMapper.selectForSellerIdByStoreId(storeId);
	    int memberId = sellerMapper.selectMemberIdForSellerId(sellerId);

	    return memberId == loginMemberId;
	}

}
