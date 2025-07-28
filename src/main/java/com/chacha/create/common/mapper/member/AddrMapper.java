package com.chacha.create.common.mapper.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.member.AddrEntity;

/**
 * address 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface AddrMapper {

    /**
     * 모든 주소 데이터를 조회합니다.
     * 
     * @return 주소 리스트
     */
    List<AddrEntity> selectAll();

    /**
     * address_id로 특정 주소 데이터를 조회합니다.
     * 
     * @param addressId 조회할 주소 ID
     * @return 조회된 AddressEntity 객체 (없으면 null)
     */
    AddrEntity selectByAddressId(int addressId);
    
    /**
     * member_id로 특정 주소 데이터를 조회합니다.
     * 
     * @param memberId 조회할 멤버 ID
     * @return 조회된 AddressEntity 객체 (없으면 null)
     */
    AddrEntity selectByMemberId(int memberId);

    /**
     * 새로운 주소 데이터를 삽입합니다.
     * seq_address_id 시퀀스를 사용하여 address_id가 자동 생성됩니다.
     * 
     * @param entity 삽입할 AddressEntity 객체
     * @return 삽입 성공 시 영향 받은 행 수
     */
    int insert(AddrEntity entity);

    /**
     * 기존 주소 데이터를 수정합니다.
     * 
     * @param entity 수정할 AddressEntity 객체
     * @return 수정 성공 시 영향 받은 행 수
     */
    int update(AddrEntity entity);

    /**
     * address_id로 주소 데이터를 삭제합니다.
     * 
     * @param addressId 삭제할 주소 ID
     * @return 삭제 성공 시 영향 받은 행 수
     */
    int delete(int addressId);

	AddrEntity selectForBaseAddr(Integer memberId);
}

