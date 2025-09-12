package com.chacha.create.controller.rest.store_common.header;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.boot.BootTokenDTO;
import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.member.RegisterDTO;
import com.chacha.create.common.entity.member.AddrEntity;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.header.auth.LoginService;
import com.chacha.create.service.store_common.header.auth.RegisterService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/auth")
@RequiredArgsConstructor
public class AuthRestController {

    private final LoginService loginService;
    private final RegisterService registerService;

    @PostMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Map<String,Object>>> login(HttpSession session, @RequestBody MemberEntity member) {
        MemberEntity loginMember = loginService.login(member.getMemberEmail(), member.getMemberPwd());
        log.info(loginMember.toString());
        session.setAttribute("loginMember", loginMember);
        
        // redirect 경로 가져오기 (없으면 기본 /main)
        String redirect = (String) session.getAttribute("redirectAfterLogin");
        if (redirect == null) redirect = "/main";
        else session.removeAttribute("redirectAfterLogin");

        Map<String, Object> data = new HashMap<>();
        data.put("loginMember", loginMember);
        data.put("redirect", redirect);
        
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, data));
    }

    @PostMapping(value = "/join/userinfo", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<MemberEntity>> userinfo(HttpSession session, @RequestBody RegisterDTO registerDTO) {
    	log.info(registerDTO.toString());
    	MemberEntity member = registerDTO.getMember();
    	AddrEntity addr = registerDTO.getAddr();
        MemberEntity loginMember = registerService.memberinsert(member, addr);
        session.setAttribute("loginMember", loginMember); // 바로 로그인
        return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                             .body(new ApiResponse<>(ResponseCode.CREATED, loginMember));
    }

    @PostMapping(value = "/join/seller", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<String>> seller(HttpServletResponse response, HttpSession session, @RequestBody SellerEntity sellerEntity) {
        MemberEntity member = (MemberEntity) session.getAttribute("loginMember");
        String accessToken = registerService.sellerinsert(sellerEntity, member, response);
        return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                             .body(new ApiResponse<>(ResponseCode.CREATED, "성공", accessToken));
    }
    
    @PostMapping("/loginSuccess")
    public ResponseEntity<ApiResponse<MemberEntity>> login(
            @RequestBody MemberEntity member,
            HttpSession session) {

        // 로그인 성공 시 세션에 저장
        session.setAttribute("loginMember", member);

        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, member));
    }
    
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(
            HttpSession session,
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        
        try {
        	log.info("로그아웃 요청 - 세션 ID: {}", session.getId());
            log.info("로그아웃 전 세션 속성: loginMember = {}", session.getAttribute("loginMember"));
            
            // 세션 무효화
            session.invalidate();
            
            log.info("로그아웃 후 세션 속성: loginMember = {}", session.getAttribute("loginMember"));
            
            Map<String, Object> response = new HashMap<>();
            response.put("message", "로그아웃 성공");
            response.put("status", 200);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("message", "로그아웃 처리 중 오류 발생");
            errorResponse.put("status", 500);
            return ResponseEntity.status(500).body(errorResponse);
        }
    }
}
