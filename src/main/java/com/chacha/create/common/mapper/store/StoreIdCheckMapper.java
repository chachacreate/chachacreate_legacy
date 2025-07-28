package com.chacha.create.common.mapper.store;


import org.apache.ibatis.annotations.Mapper;


/**
 * 접속한 URL을 통해 해당 스토어의 스토어ID를 체크
 * 해당 스토어의 상품을 보여주기 위함
 */
@Mapper
public interface StoreIdCheckMapper {
	
	/**
     * 스토어 URL로 스토어ID를 조회합니다.
     *
     * @param storeUrl 스토어 URL
     * @return 스토어 엔티티 {@code StoreID}
     */
    int selectByStoreUrl(String storeUrl);
}
