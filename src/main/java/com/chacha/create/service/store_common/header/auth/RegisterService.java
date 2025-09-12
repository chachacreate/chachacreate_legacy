package com.chacha.create.service.store_common.header.auth;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.boot.BootTokenDTO;
import com.chacha.create.common.entity.member.AddrEntity;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.common.mapper.member.AddrMapper;
import com.chacha.create.common.mapper.member.MemberMapper;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class RegisterService {

	private final MemberMapper memberMapper;
	private final SellerMapper sellerMapper;
	private final StoreMapper storeMapper;
	private final AddrMapper addrMapper;
	private final BootAPIUtil bootAPIUtil;
    
    @Transactional(rollbackFor = Exception.class)
    public MemberEntity memberinsert(MemberEntity memberEntity, AddrEntity addrEntity) {
        String password = memberEntity.getMemberPwd();
        String email = memberEntity.getMemberEmail();
        String phone = memberEntity.getMemberPhone();
        String regi = memberEntity.getMemberRegi();

        if (!isValidPassword(password)) {
            throw new InvalidRequestException("비밀번호 형식 오류");
        }
        if (!isValidEmail(email)) {
            throw new InvalidRequestException("이메일 형식 오류");
        }
        if (!isValidPhoneNumber(phone)) {
            throw new InvalidRequestException("전화번호 형식 오류");
        }
        if (!isValidRegi(regi)) {
            throw new InvalidRequestException("주민등록번호 형식 오류");
        }
        log.info(memberEntity.toString());
        log.info("addrEntity : " + addrEntity);
        try {
            memberMapper.insert(memberEntity);
            addrEntity.setMemberId(memberMapper.selectByMemberEmail(email).getMemberId());
        	addrMapper.insert(addrEntity);
            return memberMapper.selectByMemberEmail(memberEntity.getMemberEmail());
        } catch (Exception e) {
            log.info("아이디가 중복됨 : {}", email);
            throw new InvalidRequestException("이미 존재하는 이메일입니다.");
        }
    }

    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) return false;

        String specialChars = "!\"#$%&'()*+,-./:;<=>?@\\[₩\\]^_`{|}~";
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        boolean hasSpecial = password.matches(".*[" + specialChars + "].*");

        return hasLetter && hasDigit && hasSpecial;
    }
    
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$");
    }

    private boolean isValidPhoneNumber(String phone) {
        return phone != null && phone.matches("^01[016789]-\\d{3,4}-\\d{4}$");
    }

    private boolean isValidRegi(String regi) {
        return regi != null && regi.matches("^\\d{6}-[1-4]{1}$");
    }

    @Transactional(rollbackFor = Exception.class)
    public String sellerinsert(SellerEntity sellerEntity, MemberEntity memberEntity, HttpServletResponse response) {
    	sellerEntity.setMemberId(memberEntity.getMemberId());
    	sellerEntity.setPersonalCheck(1);
    	int inserted = sellerMapper.insert(sellerEntity); // insert 후 sellerId가 sellerEntity에 세팅됨
    	log.info("Inserted Seller Rows = {}", inserted); // 1이 나와야 정상
    	log.info(sellerEntity.toString());
    	
    	BootTokenDTO token = bootAPIUtil.upgradeMemberToPersonalSeller(memberEntity.getMemberId(), response);
        
        StoreEntity storeEntity = StoreEntity.builder()
                .sellerId(sellerEntity.getSellerId())  // 바로 사용
                .build();
        log.info(storeEntity.toString());
        storeMapper.insert(storeEntity);
    	return token.getAccessToken();
    }
}
