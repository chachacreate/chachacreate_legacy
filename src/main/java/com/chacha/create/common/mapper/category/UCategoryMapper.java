package com.chacha.create.common.mapper.category;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.category.UCategoryEntity;

/**
 * u_category 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface UCategoryMapper {

    /**
     * 모든 u_category 데이터를 조회합니다.
     * 
     * @return UCategoryEntity 리스트
     */
    List<UCategoryEntity> selectAll();

    /**
     * u_category_id로 u_category 데이터를 조회합니다.
     * 
     * @param uCategoryId 조회할 u_category의 ID
     * @return UCategoryEntity 객체 (없으면 null)
     */
    UCategoryEntity selectByUCategoryId(int ucategoryId);

    /**
     * type_category_id로 u_category 리스트를 조회합니다.
     * 
     * @param typeCategoryId 조회할 상위 타입 카테고리 ID
     * @return 해당 typeCategoryId에 속하는 UCategoryEntity 리스트
     */
    List<UCategoryEntity> selectByTypeCategoryId(int typecategoryId);

    /**
     * 새로운 u_category 데이터를 삽입합니다.
     * 시퀀스 seq_u_category_id를 사용합니다.
     * 
     * @param entity 삽입할 UCategoryEntity 객체
     * @return 삽입 성공 시 영향 받은 행 수
     */
    int insert(UCategoryEntity entity);

    /**
     * u_category 데이터를 수정합니다.
     * 
     * @param entity 수정할 UCategoryEntity 객체
     * @return 수정 성공 시 영향 받은 행 수
     */
    int update(UCategoryEntity entity);

    /**
     * u_category_id로 데이터를 삭제합니다.
     * 
     * @param uCategoryId 삭제할 u_category의 ID
     * @return 삭제 성공 시 영향 받은 행 수
     */
    int delete(int ucategoryId);
}
