package com.chacha.create.controller.controller.store_common;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.chacha.create.common.dto.login.KakaoClientDTO;
import com.chacha.create.common.dto.login.NaverClientDTO;
import com.chacha.create.common.entity.member.MemberEntity;
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

	    String finalRedirect = "/main"; // 기본값

	    // 1. 쿼리 파라미터에 redirect가 명시된 경우
	    if (redirect != null && !redirect.isBlank()) {
	        // 경로 통일(/ 없으면 /를 붙여서 저장)
	        finalRedirect = redirect.startsWith("/") ? redirect : "/" + redirect;
	    } else {
	        // 2. 쿼리 파라미터가 없는 경우(Referer 헤더를 사용하여 직전 페이지 정보 추출)
	        String referer = request.getHeader("Referer");
	        String contextPath = request.getContextPath(); // 예: /create

	        if (referer != null && referer.contains(request.getServerName())) {
	            try {
	                // contextPath 이후 경로만 추출
	                String pathAfterContext = referer.substring(referer.indexOf(contextPath) + contextPath.length());
	                if (!pathAfterContext.startsWith("/")) {
	                    pathAfterContext = "/" + pathAfterContext;
	                }

	                // 중복된 contextPath 제거 (ex. /create/create)
	                finalRedirect = pathAfterContext.startsWith(contextPath)
	                        ? pathAfterContext.substring(contextPath.length())
	                        : pathAfterContext;

	                if (!finalRedirect.startsWith("/")) {
	                    finalRedirect = "/" + finalRedirect;
	                }

	            } catch (Exception e) {
	                log.warn("⚠️ [login] redirect 계산 실패, 기본값 사용", e);
	            }
	        }
	    }

	    // 최종 리다이렉트 경로 세션에 저장
	    session.setAttribute("redirectAfterLogin", finalRedirect);

	    // ✅ 카카오 로그인 URL 구성
	    String kakaoLogin = "https://kauth.kakao.com/oauth/authorize?response_type=code"
	            + "&client_id=" + kakaoClientDTO.getClientId()
	            + "&redirect_uri=" + kakaoClientDTO.getRedirectUri();
	    model.addAttribute("kakaoLogin", kakaoLogin);

	    // ✅ 네이버 로그인 URL 구성
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
	public String logout(HttpServletRequest request, HttpSession session) {
	    String referer = request.getHeader("Referer");
	    String contextPath = request.getContextPath();

	    String redirectAfterLogout = "/main"; // 기본값

	    if (referer != null && referer.contains(request.getServerName())) {
	        try {
	            String pathAfterContext = referer.substring(referer.indexOf(contextPath) + contextPath.length());
	            if (!pathAfterContext.startsWith("/")) {
	                pathAfterContext = "/" + pathAfterContext;
	            }

	            redirectAfterLogout = pathAfterContext.startsWith(contextPath)
	                    ? pathAfterContext.substring(contextPath.length())
	                    : pathAfterContext;

	            if (!redirectAfterLogout.startsWith("/")) {
	                redirectAfterLogout = "/" + redirectAfterLogout;
	            }
	        } catch (Exception e) {
	            log.warn("⚠️ [logout] redirect 계산 실패, 기본값 사용", e);
	        }
	    }

	    session.invalidate(); // 세션 무효화

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
