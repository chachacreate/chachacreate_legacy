package com.chacha.create.controller.rest.mainhome.personal;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.mainhome.personal.PersonalInfoService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/main/sell")
public class PersonalInfoRestController {
	
	@Autowired
	PersonalInfoService personalInfoService;
	
    @GetMapping("/info")
    public ResponseEntity<ApiResponse<SellerEntity>> getSellerInfo(HttpSession session) {
        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        SellerEntity seller = personalInfoService.selectByMemberId(loginMember.getMemberId());
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, seller));
    }
    
    @PostMapping("/info")
    public ResponseEntity<ApiResponse<SellerEntity>> changeAccount(HttpSession session, @RequestBody SellerEntity sellerInfo) {
    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        SellerEntity seller = personalInfoService.selectByMemberId(loginMember.getMemberId());
        
        personalInfoService.updateSellerInfo(sellerInfo, loginMember.getMemberId());
        SellerEntity updatedSeller = personalInfoService.selectByMemberId(loginMember.getMemberId());
        
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, updatedSeller));
    }
}
