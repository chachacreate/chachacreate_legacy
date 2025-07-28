package com.chacha.create.common.mapper.store;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.entity.store.NoticeEntity;

/**
 * {@code notice} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 공지사항 등록, 조회, 수정, 삭제 기능을 제공합니다.
 */
@Mapper
public interface NoticeMapper {

    /**
     * 전체 공지사항을 조회합니다.
     *
     * @return {@code List<NoticeEntity>} 전체 공지 목록
     */
    List<NoticeEntity> selectAll();

    /**
     * 공지 ID로 공지를 조회합니다.
     *
     * @param noticeId 공지 ID
     * @return {@code NoticeEntity} 해당 공지 객체
     */
    NoticeEntity selectByNoticeId(int noticeId);

    /**
     * 스토어 ID로 공지 목록을 조회합니다.
     *
     * @param storeId 스토어 ID
     * @return {@code List<NoticeEntity>} 해당 스토어의 공지 목록
     */
    List<NoticeEntity> selectByStoreId(int storeId);

    /**
     * 새로운 공지사항을 등록합니다.
     * 공지 ID는 Oracle 시퀀스 {@code seq_notice_id.NEXTVAL}로 자동 생성됩니다.
     *
     * @param noticeEntity 등록할 공지 객체
     * @return 영향 받은 행 수
     */
    int insert(NoticeEntity noticeEntity);

    /**
     * 기존 공지사항을 수정합니다.
     *
     * @param noticeEntity 수정할 공지 객체
     * @return 영향 받은 행 수
     */
    int update(NoticeEntity noticeEntity);

    /**
     * 공지 ID로 공지사항을 삭제합니다.
     *
     * @param noticeId 삭제할 공지 ID
     * @return 영향 받은 행 수
     */
    int delete(int noticeId);
    
    List<Map<String, Object>> noticeList(String storeUrl);

    List<Map<String, Object>> noticeDetailList(@Param("storeUrl") String storeUrl, @Param("noticeId") int noticeId);
}
