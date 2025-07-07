package com.chacha.create.common.mapper.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.member.MemberEntity;

/**
 * MEMBER 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface MemberMapper {

    /**
     * 모든 회원 정보를 조회합니다.
     * 
     * @return 회원 리스트
     */
    List<MemberEntity> selectAll();

    /**
     * 회원 ID로 특정 회원 정보를 조회합니다.
     * 
     * @param memberId 조회할 회원 ID
     * @return 조회된 MemberEntity 객체 (없으면 null)
     */
    MemberEntity selectByMemberId(int memberId);

    /**
     * 회원 EMAIL로 특정 회원 정보를 조회합니다.
     * 
     * @param memberEmail 조회할 회원 ID
     * @return 조회된 MemberEntity 객체 (없으면 null)
     */
    MemberEntity selectByMemberEmail(String memberEmail);

    /**
     * 새로운 회원 정보를 삽입합니다.
     * seq_member_id 시퀀스를 사용하여 MEMBER_ID가 자동 생성됩니다.
     * 
     * @param member 삽입할 MemberEntity 객체
     * @return 삽입 성공 시 영향 받은 행 수
     */
    int insert(MemberEntity member);

    /**
     * 기존 회원 정보를 수정합니다.
     * 
     * @param member 수정할 MemberEntity 객체
     * @return 수정 성공 시 영향 받은 행 수
     */
    int update(MemberEntity member);
    
    // 비밀번호만 변경
    int updatePwd(MemberEntity member);
    /**
     * 회원 ID로 회원 정보를 삭제합니다.
     * 
     * @param memberId 삭제할 회원 ID
     * @return 삭제 성공 시 영향 받은 행 수
     */
    int delete(int memberId);
    
    int updateMemberInfo(MemberEntity member);
    
}
