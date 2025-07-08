package com.chacha.create.common.mapper.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.store.QuestionEntity;

/**
 * {@code question} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 상품 문의에 대한 등록, 조회, 수정, 삭제 기능을 제공합니다.
 */
@Mapper
public interface QuestionMapper {

    /**
     * 전체 문의 목록을 조회합니다.
     *
     * @return {@code List<QuestionEntity>} 모든 문의 목록
     */
    List<QuestionEntity> selectAll();

    /**
     * 문의 ID로 문의를 조회합니다.
     *
     * @param questionId 문의 ID
     * @return {@code QuestionEntity} 해당 문의 객체
     */
    QuestionEntity selectByQuestionId(int questionId);

    /**
     * 스토어 ID로 문의 목록을 조회합니다.
     *	
     * @param storeId 스토어 ID
     * @return {@code List<QuestionEntity>} 해당 스토어의 문의 목록
     */
    List<QuestionEntity> selectByStoreId(int storeId);

    /**
     * 회원 ID로 문의 목록을 조회합니다.
     *
     * @param memberId 회원 ID
     * @return {@code List<QuestionEntity>} 해당 회원의 문의 목록
     */
    List<QuestionEntity> selectByMemberId(int memberId);

    /**
     * 새로운 문의를 등록합니다.
     * 문의 ID는 시퀀스 {@code seq_question_id.NEXTVAL}로 자동 생성됩니다.
     *
     * @param questionEntity 등록할 문의 객체
     * @return 영향 받은 행 수
     */
    int insert(QuestionEntity questionEntity);

    /**
     * 기존 문의를 수정합니다.
     *
     * @param questionEntity 수정할 문의 객체
     * @return 영향 받은 행 수
     */
    int update(QuestionEntity questionEntity);

    /**
     * 문의 ID로 해당 문의를 삭제합니다.
     *
     * @param questionId 삭제할 문의 ID
     * @return 영향 받은 행 수
     */
    int delete(int questionId);
}
