package com.chacha.create.common.mapper.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.dto.manager.ManagerAdjustmentDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.entity.store.StoreEntity;

/**
 * {@code store} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 스토어에 대한 CRUD 연산을 제공합니다.
 */
@Mapper
public interface StoreMapper {

    /**
     * 모든 스토어 정보를 조회합니다.
     *
     * @return 스토어 목록 {@code List<StoreEntity>}
     */
    List<StoreEntity> selectAll();

    /**
     * 스토어 ID로 특정 스토어를 조회합니다.
     *
     * @param storeId 스토어 ID
     * @return 스토어 엔티티 {@code StoreEntity}
     */
    StoreEntity selectByStoreId(int storeId);

    /**
     * 스토어 URL로 특정 스토어를 조회합니다.
     *
     * @param storeUrl 스토어 URL
     * @return 스토어 엔티티 {@code StoreEntity}
     */
    StoreEntity selectByStoreUrl(String storeUrl);

    /**
     * 판매자 ID로 해당 판매자의 스토어를 조회합니다.
     *
     * @param sellerId 판매자 ID
     * @return 스토어 엔티티 {@code StoreEntity}
     */
    StoreEntity selectBySellerId(int sellerId);

    
    /**
     * 스토어ID로 판매자ID 조회 
     *
     * @param 조회하려는 판매자의 스토어ID
     * @return 해당 스토어의 판매자ID
     */
    int selectForSellerIdByStoreId(int storeId);
    
    /**
     * 새로운 스토어를 등록합니다.
     * 스토어 ID는 {@code seq_store_id.NEXTVAL}을 통해 자동 생성됩니다.
     *
     * @param storeEntity 등록할 스토어 정보
     * @return 처리된 행 수
     */
    int insert(StoreEntity storeEntity);

    /**
     * 스토어 정보를 수정합니다.
     *
     * @param storeEntity 수정할 스토어 정보
     * @return 처리된 행 수
     */
    int update(StoreEntity storeEntity);

    /**
     * 스토어 ID로 해당 스토어를 삭제합니다.
     *
     * @param storeId 삭제할 스토어 ID
     * @return 처리된 행 수
     */
    int delete(int storeId);
    
    List<StoreEntity> selectByStoreInfo(String storeUrl);
    
    int updateStoreInfo(StoreEntity storeEntity);

	int selectForCountUrlByStoreUrl(String storeUrl);

	int selectForCountProductByMemberId(Integer memberId);

	StoreInfoDTO selectForThisStoreInfo(String storeUrl);
	
	int updatePersonalCheck(int sellerId);

}
