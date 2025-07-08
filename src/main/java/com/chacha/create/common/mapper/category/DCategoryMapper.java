package com.chacha.create.common.mapper.category;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.category.DCategoryEntity;

/**
 * d_category 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface DCategoryMapper {

    /**
     * d_category 테이블의 모든 데이터를 조회합니다.
     *
     * @return 상세 카테고리 목록
     */
    List<DCategoryEntity> selectAll();

    /**
     * 상세 카테고리 ID로 해당 카테고리를 조회합니다.
     *
     * @param dCategoryId 상세 카테고리 ID
     * @return 조회된 상세 카테고리 객체 (없으면 null)
     */
    DCategoryEntity selectByDCategoryId(int dcategoryId);

    /**
     * 상위 카테고리 ID에 속하는 상세 카테고리 목록을 조회합니다.
     *
     * @param uCategoryId 상위 카테고리 ID
     * @return 상세 카테고리 목록
     */
    List<DCategoryEntity> selectByUCategoryId(int ucategoryId);

    /**
     * 시퀀스를 사용하여 새로운 상세 카테고리를 등록합니다.
     *
     * @param entity 등록할 상세 카테고리 객체
     * @return 등록된 행의 수
     */
    int insert(DCategoryEntity entity);

    /**
     * 상세 카테고리 정보를 수정합니다.
     *
     * @param entity 수정할 상세 카테고리 객체
     * @return 수정된 행의 수
     */
    int update(DCategoryEntity entity);

    /**
     * 상세 카테고리 ID로 해당 데이터를 삭제합니다.
     *
     * @param dCategoryId 삭제할 상세 카테고리 ID
     * @return 삭제된 행의 수
     */
    int delete(int dcategoryId);
}
