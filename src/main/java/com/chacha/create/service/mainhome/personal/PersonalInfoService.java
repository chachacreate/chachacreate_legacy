package com.chacha.create.service.mainhome.personal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.mapper.member.SellerMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PersonalInfoService {
	
	@Autowired
	SellerMapper sellerMapper;
	
	public SellerEntity selectByMemberId(int memberId) {
		return sellerMapper.selectByMemberId(memberId);
	}
	
	public int updateSellerInfo(SellerEntity sellerInfo, int memberId) {
		
	    SellerEntity seller = sellerMapper.selectByMemberId(memberId);

	    // 계좌 정보 수정
	    if (sellerInfo.getAccountBank() != null && !sellerInfo.getAccountBank().isBlank()) {
	        seller.setAccountBank(sellerInfo.getAccountBank());
	    }
	    if (sellerInfo.getAccount() != null && !sellerInfo.getAccount().isBlank()) {
	        seller.setAccount(sellerInfo.getAccount());
	    }

	    // 프로필 정보 수정
	    if (sellerInfo.getProfileInfo() != null) {
	        seller.setProfileInfo(sellerInfo.getProfileInfo());
	    }
	    
		return sellerMapper.updateSellerInfo(seller);
	}

	public boolean selectForSellerByMemberId(MemberEntity loginMember) {
		return sellerMapper.selectByMemberId(loginMember.getMemberId())==null?true:false;
	}
	
	public boolean selectForPersonalcheckByMemberId(MemberEntity loginMember) {
		return sellerMapper.selectByMemberId(loginMember.getMemberId()).getPersonalCheck()==1?true:false;
	}
	
}
