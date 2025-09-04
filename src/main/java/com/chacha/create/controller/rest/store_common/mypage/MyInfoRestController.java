package com.chacha.create.controller.rest.store_common.mypage;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.boot.BootMemberDTO;
import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.mypage.MyInfoService;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/legacy/{storeUrl}/mypage")
public class MyInfoRestController {

    private final MyInfoService myInfoService;
    private final BootAPIUtil bootAPIUtil;
    
	// 회원 정보 불러오기
	@GetMapping
	public ResponseEntity<ApiResponse<MemberEntity>> getMyInfo(HttpSession session) {
		MemberEntity member = (MemberEntity) session.getAttribute("loginMember");
		if (member == null) {
			return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
					.body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
		}
		BootMemberDTO bootMember = bootAPIUtil.getBootMemberDataByMemberId(member.getMemberId());
		MemberEntity responseMember = MemberEntity.builder()
				.memberId(bootMember.getId().intValue())
				.memberEmail(bootMember.getEmail())
				.memberName(bootMember.getName())
				.memberPhone(bootMember.getPhone())
				.memberRegi(bootMember.getRegistrationNumber())
				.memberPwd(bootMember.getPassword())
				.build();
		log.debug(responseMember.toString());
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, responseMember));
	}

    
    // 회원 정보 수정
    @PostMapping(value = "/update", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<String>> mypageUpdate(HttpSession session) {
        MemberEntity member = (MemberEntity) session.getAttribute("loginMember");

        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
        }

        int result = myInfoService.memberupdate(member);

        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "회원 정보 수정 완료"));
        } else {
            return ResponseEntity.status(ResponseCode.BAD_REQUEST.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "회원 정보 수정 실패"));
        }
    }
    
    // 회원 비밀번호 변경
    @PostMapping(value = "/update/password", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<String>> updatePassword(@RequestBody MemberEntity member, HttpSession session) {
        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
        }
        
        loginMember.setMemberPwd(member.getMemberPwd());

        int result = myInfoService.updatePwd(loginMember);
        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "비밀번호가 수정되었습니다."));
        } else {
            return ResponseEntity.status(ResponseCode.BAD_REQUEST.getStatus())
                    .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "비밀번호 수정 실패"));
        }
    }



    // 회원 탈퇴
    @PostMapping(value = "/delete", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<String>> mypageDelete(HttpSession session) {
        MemberEntity member = (MemberEntity) session.getAttribute("loginMember");

        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
        }

        int result = myInfoService.memberdelete(member.getMemberId());

        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "회원 탈퇴 완료"));
        } else {
            return ResponseEntity.status(ResponseCode.BAD_REQUEST.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "회원 탈퇴 실패"));
        }
    }
}

