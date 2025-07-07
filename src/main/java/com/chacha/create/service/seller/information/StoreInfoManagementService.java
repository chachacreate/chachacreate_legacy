package com.chacha.create.service.seller.information;

import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.store.StoreInfoManagementDTO;
import com.chacha.create.common.mapper.store.StoreInfoMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreInfoManagementService {
	
	private final StoreInfoMapper storeInfoMapper;

    public StoreInfoManagementDTO getStoreInfo(String storeUrl) {
        return storeInfoMapper.selectStoreInfoByUrl(storeUrl);
    }
}
