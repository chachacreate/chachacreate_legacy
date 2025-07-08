package com.chacha.create.controller.controller.store_common;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
	public String login(@RequestParam(value = "redirect", required = false) String redirect,
	                    HttpServletRequest request, HttpSession session, Model model) {
	    if (redirect != null) {
	        session.setAttribute("redirectAfterLogin", redirect.startsWith("/") ? redirect : "/" + redirect);
	        log.info("redirectAfterLogin set by param: {}", redirect);
	    } else {
	        String referer = request.getHeader("Referer");
	        if (referer != null && referer.contains(request.getServerName())) {
	        	String contextPath = request.getContextPath();
	        	String pathAfterContext = referer.substring(referer.indexOf(contextPath) + contextPath.length());

	        	if (!pathAfterContext.startsWith("/")) {
	        	    pathAfterContext = "/" + pathAfterContext;
	        	}
	        	
	        	String redirectPath;
	        	if (referer.contains(contextPath)) {
	        		// 경로에 /create가 포함되어 있으면 그대로
	        	    redirectPath = pathAfterContext;
	        	} else {
	        		// 없으면 붙여서
	        	    redirectPath = contextPath + pathAfterContext;
	        	}

	        	session.setAttribute("redirectAfterLogin", redirectPath);
	        	log.info("redirectAfterLogin set by referer: {}", redirectPath);

	        }
	    }

	    // 카카오 로그인 URL 구성
	    String kakaoLogin = "https://kauth.kakao.com/oauth/authorize?response_type=code"
	            + "&client_id=" + kakaoClientDTO.getClientId()
	            + "&redirect_uri=" + kakaoClientDTO.getRedirectUri();
	    model.addAttribute("kakaoLogin", kakaoLogin);

	    // 네이버 로그인 URL 구성
	    String naverLogin = "https://nid.naver.com/oauth2.0/authorize?response_type=code"
	            + "&client_id=" + naverClientDTO.getClientId()
	            + "&redirect_uri=" + naverClientDTO.getRedirectUri()
	            + "&state=state";
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

	    // 일단 필요 코드 넣어 두는데 jsp가 홈으로 돌아가기로 되어 있어서 추후 수정 필요
	    Object pendingRedirect = session.getAttribute("pendingRedirectAfterJoin");
	    if (pendingRedirect != null) {
	        session.setAttribute("redirectAfterLogin", pendingRedirect);
	        session.removeAttribute("pendingRedirectAfterJoin");
	    }

	    return "auth/join/joinComplete";
	}

	
	@GetMapping("/join/seller")
	public String loginInfo(HttpSession session) {
		session.removeAttribute("kakaoemail");
		return "auth/join/joinSeller";
	}
	
	@GetMapping("/logout")
	public String logout_page(HttpServletRequest request, HttpSession session) {
	    // 로그아웃하기 전에 현재 페이지나 Referer 가져오기
	    String referer = request.getHeader("Referer");
	    String contextPath = request.getContextPath();

	    String redirectAfterLogout = "/main"; // 기본값

	    if (referer != null && referer.contains(request.getServerName())) {
	        String pathAfterContext = referer.substring(referer.indexOf(contextPath) + contextPath.length());
	        if (!pathAfterContext.startsWith("/")) {
	            pathAfterContext = "/" + pathAfterContext;
	        }
	        redirectAfterLogout = pathAfterContext;
	    }

	    session.setAttribute("redirectAfterLogout", redirectAfterLogout);
	    session.invalidate();

	    return "redirect:" + redirectAfterLogout;
	}

	
	@GetMapping("/kakao")
	public String kakao(@RequestParam("code") String code, HttpSession session, Model model) throws IOException {
	    String accessToken = kakaoService.getAccessTokenFromKakao(code);
	    Map<String, Object> userInfo = kakaoService.getUserInfo(accessToken);

	    String email = (String) userInfo.get("email");
	    MemberEntity memberEntity = loginService.socialLogin(email);

	    if (memberEntity == null) {
	        session.setAttribute("kakaoemail", email);

	        // redirectAfterLogin 값 보존
	        Object redirect = session.getAttribute("redirectAfterLogin");
	        if (redirect != null) {
	            session.setAttribute("pendingRedirectAfterJoin", redirect);
	        }

	        return "redirect:/auth/join/agree";
	    }

	    session.setAttribute("loginMember", memberEntity);
	    log.info("email = {}", email);
	    log.info("accessToken = {}", accessToken);

	    String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
	    session.removeAttribute("redirectAfterLogin");

	    return "redirect:" + (redirectUrl != null ? redirectUrl : "/main");
	}

	@GetMapping("/naver")
	public String naver(@RequestParam("code") String code, HttpSession session, Model model) throws IOException {
	    String accessToken = naverService.getAccessTokenFromNaver(code, "test");
	    Map<String, Object> userInfo = naverService.getUserInfoFromNaver(accessToken);

	    String email = (String) userInfo.get("email");
	    MemberEntity memberEntity = loginService.socialLogin(email);

	    if (memberEntity == null) {
	        session.setAttribute("naverInfo", userInfo);

	        // redirectAfterLogin 값 보존
	        Object redirect = session.getAttribute("redirectAfterLogin");
	        if (redirect != null) {
	            session.setAttribute("pendingRedirectAfterJoin", redirect);
	        }

	        return "redirect:/auth/join/agree";
	    }

	    session.setAttribute("loginMember", memberEntity);
	    log.info("email = {}", email);
	    log.info("accessToken = {}", accessToken);

	    String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
	    session.removeAttribute("redirectAfterLogin");

	    return "redirect:" + (redirectUrl != null ? redirectUrl : "/main");
	}

}
