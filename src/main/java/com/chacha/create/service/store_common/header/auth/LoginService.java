package com.chacha.create.service.store_common.header.auth;

import org.springframework.stereotype.Service;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.exception.LoginFailException;
import com.chacha.create.common.mapper.member.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class LoginService {

	private final MemberMapper memberMapper;
	public MemberEntity login(String memberEmail, String memberPwd) {
	    MemberEntity memberEntity = memberMapper.selectByMemberEmail(memberEmail);

	    if (memberEntity == null) {
	        throw new LoginFailException("아이디가 존재하지 않음");
	    }
	    if (!memberPwd.equals(memberEntity.getMemberPwd())) {
	        throw new LoginFailException("비밀번호가 틀림");
	    }

	    log.info("로그인 성공");
	    return memberEntity;
	}
	
	public MemberEntity socialLogin(String memberEmail) {
		MemberEntity memberEntity = memberMapper.selectByMemberEmail(memberEmail);
		return memberEntity;
	}

	
}
