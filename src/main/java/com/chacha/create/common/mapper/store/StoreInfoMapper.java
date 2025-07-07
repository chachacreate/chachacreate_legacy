package com.chacha.create.common.mapper.store;
import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.dto.store.StoreInfoManagementDTO;

@Mapper
public interface StoreInfoMapper {
	StoreInfoManagementDTO selectStoreInfoByUrl(String storeUrl);
}
