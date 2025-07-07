package com.chacha.create.service.buyer.storeinfo;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.member.SellerInfoDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.mapper.manage.ManageMapper;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.product.PImgMapper;
import com.chacha.create.common.mapper.product.ProductManageMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StoreInfoService {
	
	private final StoreMapper storeMapper;
	private final ManageMapper manageMapper;
	
	public List<StoreEntity> selectByStoreInfo(String storeUrl) {

		List<StoreEntity> result =  storeMapper.selectByStoreInfo(storeUrl);
		return result;
	}
	
	public List<SellerInfoDTO> selectBySellerInfo(String storeUrl){
		List<SellerInfoDTO> result = manageMapper.selectBySellerInfo(storeUrl);
		return result;
	}

	public StoreInfoDTO selectForThisStoreInfo(String storeUrl) {
		StoreInfoDTO result =  storeMapper.selectForThisStoreInfo(storeUrl);
		return result;
	}
	
}
