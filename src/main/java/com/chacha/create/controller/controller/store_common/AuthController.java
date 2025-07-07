package com.chacha.create.controller.controller.store_common;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.login.KakaoClientDTO;
import com.chacha.create.common.dto.login.NaverClientDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.store_common.header.auth.KakaoService;
import com.chacha.create.service.store_common.header.auth.LoginService;
import com.chacha.create.service.store_common.header.auth.NaverService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/auth")
public class AuthController {
	
	@Autowired
	private KakaoClientDTO kakaoClientDTO;
	
	@Autowired
	private NaverClientDTO naverClientDTO;
	
	@Autowired
	private KakaoService kakaoService;

	@Autowired
	private NaverService naverService;
	
	@Autowired
	private LoginService loginService;
    
	@GetMapping("/login")
	public String login(Model model) {
		 String kakaoLogin = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+kakaoClientDTO.getClientId()+"&redirect_uri="+kakaoClientDTO.getRedirectUri();
	     model.addAttribute("kakaoLogin", kakaoLogin);
	     String naverLogin = "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id="+naverClientDTO.getClientId()+"&redirect_uri="+naverClientDTO.getRedirectUri()+"&state=test";
	     model.addAttribute("naverLogin", naverLogin);
		return "auth/login";
	}
	
	@GetMapping("/join/agree")
	public String joinAgree() {
		return "auth/join/joinAgree";
	}
	
	@GetMapping("/join/userinfo")
	public String joinInfo() {
		return "auth/join/joinInfo";
	}
	
	@GetMapping("/join/complete")
	public String joinComplete(HttpSession session) {
		session.removeAttribute("kakaoemail");
		session.removeAttribute("naverInfo");
		return "auth/join/joinComplete";
	}
	
	@GetMapping("/join/seller")
	public String loginInfo(HttpSession session) {
		session.removeAttribute("kakaoemail");
		return "auth/join/joinSeller";
	}
	
	@GetMapping("/logout")
	public String logout_page(HttpSession session) {
		session.invalidate();
		return "redirect:/main";
	}
	
    @GetMapping("/kakao")
    public String kakao(@RequestParam("code") String code, HttpSession session, Model model) throws IOException {
        String accessToken = kakaoService.getAccessTokenFromKakao(code);
        Map<String, Object> userInfo = kakaoService.getUserInfo(accessToken);

        String email = (String)userInfo.get("email");
        MemberEntity memberEntity = loginService.socialLogin(email);
        if(memberEntity == null) {
        	session.setAttribute("kakaoemail", email);
        	return "redirect:/auth/join/agree";
        }
        session.setAttribute("loginMember", memberEntity);
        log.info("email = " + email);
        log.info("accessToken = " + accessToken);
        return "redirect:/main";
    }
    @GetMapping("/naver")
    public String naver(@RequestParam("code") String code, HttpSession session, Model model) throws IOException {
        String accessToken = naverService.getAccessTokenFromNaver(code, "test");
        Map<String, Object> userInfo = naverService.getUserInfoFromNaver(accessToken);

        String email = (String)userInfo.get("email");
        MemberEntity memberEntity = loginService.socialLogin(email);
        if(memberEntity == null) {
        	session.setAttribute("naverInfo", userInfo);
        	return "redirect:/auth/join/agree";
        }
        session.setAttribute("loginMember", memberEntity);
        log.info("email = " + email);
        log.info("accessToken = " + accessToken);
        return "redirect:/main";
    }
}
