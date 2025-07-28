package com.chacha.create.service.store_common.mypage;


import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.mapper.member.MemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MyInfoService {
	
	private final MemberMapper memberMapper;
	
	@Transactional(rollbackFor = Exception.class)
	public MemberEntity selectByMemberId(int memeberId) {
		return memberMapper.selectByMemberId(memeberId);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int memberupdate(MemberEntity memberEntity) {
		int result = memberMapper.update(memberEntity);
		return result;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int updatePwd(MemberEntity memberEntity) {
		return memberMapper.updatePwd(memberEntity);
	}

	@Transactional(rollbackFor = Exception.class)
	public int memberdelete(int memberId) {
		int result = memberMapper.delete(memberId);
		return result;
	}
}
