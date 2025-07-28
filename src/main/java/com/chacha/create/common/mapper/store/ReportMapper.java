package com.chacha.create.common.mapper.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.store.ReportEntity;

/**
 * {@code report} 테이블에 대한 MyBatis 매퍼 인터페이스입니다.
 * 신고 기능에 대한 CRUD 연산을 제공합니다.
 */
@Mapper
public interface ReportMapper {

    /**
     * 전체 신고 목록을 조회합니다.
     *
     * @return 신고 목록 {@code List<ReportEntity>}
     */
    List<ReportEntity> selectAll();

    /**
     * 신고 ID로 신고 상세 정보를 조회합니다.
     *
     * @param reportId 신고 ID
     * @return 신고 엔티티 {@code ReportEntity}
     */
    ReportEntity selectByReportId(int reportId);

    /**
     * 회원 ID로 해당 회원이 등록한 신고 목록을 조회합니다.
     *
     * @param memberId 회원 ID
     * @return 신고 목록 {@code List<ReportEntity>}
     */
    List<ReportEntity> selectByMemberId(int memberId);

    /**
     * 판매자 ID로 해당 판매자에 대한 신고 목록을 조회합니다.
     *
     * @param sellerId 판매자 ID
     * @return 신고 목록 {@code List<ReportEntity>}
     */
    List<ReportEntity> selectBySellerId(int sellerId);

    /**
     * 새 신고를 등록합니다.
     * 신고 ID는 시퀀스 {@code seq_report_id.NEXTVAL}을 통해 자동 생성됩니다.
     *
     * @param reportEntity 등록할 신고 정보
     * @return 처리된 행 수
     */
    int insert(ReportEntity reportEntity);

    /**
     * 신고 정보를 수정합니다.
     *
     * @param reportEntity 수정할 신고 정보
     * @return 처리된 행 수
     */
    int update(ReportEntity reportEntity);

    /**
     * 신고 ID로 해당 신고를 삭제합니다.
     *
     * @param reportId 삭제할 신고 ID
     * @return 처리된 행 수
     */
    int delete(int reportId);

}
