package com.chacha.create.service.seller.information;

import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.boot.BootMemberDTO;
import com.chacha.create.common.dto.store.StoreInfoManagementDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.mapper.store.StoreInfoMapper;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreInfoManagementService {
	
	private final StoreInfoMapper storeInfoMapper;
	private final BootAPIUtil bootAPIUtil;

    public StoreInfoManagementDTO getStoreInfo(String storeUrl, MemberEntity loginMember) {
    	StoreInfoManagementDTO sidto = storeInfoMapper.selectStoreInfoByUrl(storeUrl);
    	BootMemberDTO bmd =  bootAPIUtil.getBootMemberDataByMemberId(loginMember.getMemberId());
    	if(bmd.equals(null)) {
    		return null;
    	}
    	sidto.setMemberEmail(bmd.getEmail());
    	sidto.setMemberName(bmd.getName());
    	sidto.setMemberPhone(bmd.getPhone());
    	log.debug(sidto.toString());
        return sidto;
    }
}
