package com.chacha.create.service.manager.member;

import java.util.List;

import org.springframework.stereotype.Service;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.mapper.member.MemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberManagementService {

	private final MemberMapper memberMapper;

	public List<MemberEntity> selectAll() {
		return memberMapper.selectAll();
	}
	
	public MemberEntity selectById(int memberId) {
		return memberMapper.selectByMemberId(memberId);
	}

}
