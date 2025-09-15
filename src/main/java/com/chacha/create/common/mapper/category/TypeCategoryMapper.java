package com.chacha.create.common.mapper.category;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.dto.store.StoreCategoryDTO;
import com.chacha.create.common.entity.category.TypeCategoryEntity;

/**
 * type_category 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface TypeCategoryMapper {

    /**
     * type_category 테이블의 모든 데이터를 조회합니다.
     *
     * @return 타입 카테고리 목록
     */
    List<TypeCategoryEntity> selectAll();

    /**
     * 타입 카테고리 ID로 해당 데이터를 조회합니다.
     *
     * @param typeCategoryId 타입 카테고리 ID
     * @return 조회된 타입 카테고리 객체 (없으면 null)
     */
    TypeCategoryEntity selectByTypeCategoryId(int typeCategoryId);

    /**
     * 시퀀스를 사용하여 새로운 타입 카테고리를 등록합니다.
     *
     * @param entity 등록할 타입 카테고리 객체
     * @return 등록된 행의 수
     */
    int insert(TypeCategoryEntity entity);

    /**
     * 타입 카테고리 정보를 수정합니다.
     *
     * @param entity 수정할 타입 카테고리 객체
     * @return 수정된 행의 수
     */
    int update(TypeCategoryEntity entity);

    /**
     * 타입 카테고리 ID로 해당 데이터를 삭제합니다.
     *
     * @param typeCategoryId 삭제할 타입 카테고리 ID
     * @return 삭제된 행의 수
     */
    int delete(int typeCategoryId);
    
    // 스토어 상품 중 가장 많은 category 이름 가져오기
    Map<String, Object> selectTopStoreCategories(int storeId);
}
