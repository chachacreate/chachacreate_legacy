package com.chacha.create.controller.controller.store_common;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.chacha.create.common.dto.boot.BootTokenDTO;
import com.chacha.create.common.dto.login.KakaoClientDTO;
import com.chacha.create.common.dto.login.NaverClientDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.service.store_common.header.auth.KakaoService;
import com.chacha.create.service.store_common.header.auth.LoginService;
import com.chacha.create.service.store_common.header.auth.NaverService;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

	private final KakaoClientDTO kakaoClientDTO;
	private final NaverClientDTO naverClientDTO;
	private final KakaoService kakaoService;
	private final NaverService naverService;
	private final LoginService loginService;
	private final BootAPIUtil bootAPIUtil;
    
	@GetMapping("/login")
	public String login(@RequestParam(value = "redirect", required = false) String redirect,
	                    HttpServletRequest request, HttpSession session, Model model) {

	    String finalRedirect = "/main"; // 기본값

	    if (redirect != null && !redirect.isBlank()) {
	        if (redirect.startsWith("http")) {
	            // 절대 URL이면 URI 파싱해서 경로만 추출
	            try {
	                URI  uri = new URI(redirect);
	                finalRedirect = uri.getPath();
	                if (uri.getQuery() != null) {
	                    finalRedirect += "?" + uri.getQuery();
	                }
	                if (!finalRedirect.startsWith("/")) {
	                    finalRedirect = "/" + finalRedirect;
	                }
	            } catch (URISyntaxException e) {
	                finalRedirect = "/main";
	            }
	        } else {
	            // 상대경로인 경우 / 붙여서 통일
	            finalRedirect = redirect.startsWith("/") ? redirect : "/" + redirect;
	        }
	    } else {
	        String referer = request.getHeader("Referer");
	        String contextPath = request.getContextPath();

	        if (referer != null && referer.contains(request.getServerName())) {
	            try {
	                String pathAfterContext = referer.substring(referer.indexOf(contextPath) + contextPath.length());
	                if (!pathAfterContext.startsWith("/")) {
	                    pathAfterContext = "/" + pathAfterContext;
	                }
	                finalRedirect = pathAfterContext.startsWith(contextPath)
	                        ? pathAfterContext.substring(contextPath.length())
	                        : pathAfterContext;

	                if (!finalRedirect.startsWith("/")) {
	                    finalRedirect = "/" + finalRedirect;
	                }

	            } catch (Exception e) {
	                finalRedirect = "/main";
	            }
	        }
	    }

	    // 최종 리다이렉트 경로 세션에 저장
	    session.setAttribute("redirectAfterLogin", finalRedirect);

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
		session.removeAttribute("naverInfo");
		return "auth/join/joinSeller";
	}
	
	@GetMapping("/logout")
	public String logout(HttpServletRequest request, HttpSession session) {
	    String referer = request.getHeader("Referer");
	    String contextPath = request.getContextPath();

	    String redirectAfterLogout = "/main"; // 기본값

	    if (referer != null && referer.contains(request.getServerName())) {
	        try {
	            URI refererUri = new URI(referer);
	            String path = refererUri.getPath();

	            if (path != null && path.startsWith(contextPath)) {
	                path = path.substring(contextPath.length());
	            }
	            if (path == null || path.isBlank()) {
	                path = "/";
	            }
	            if (!path.startsWith("/")) {
	                path = "/" + path;
	            }

	            redirectAfterLogout = path;

	        } catch (URISyntaxException e) {
	            log.warn("⚠️ [logout] Referer 파싱 실패, 기본값 사용", e);
	        }
	    }

	    session.invalidate(); // 세션 무효화

	    return "redirect:" + redirectAfterLogout;
	}


	
	@GetMapping("/kakao")
	public String kakao(@RequestParam("code") String code, HttpSession session, Model model, HttpServletResponse response) throws IOException {
	    String accessToken = kakaoService.getAccessTokenFromKakao(code);
	    Map<String, Object> userInfo = kakaoService.getUserInfo(accessToken);

	    String email = (String) userInfo.get("email");
	    BootTokenDTO bootTokenDTO = bootAPIUtil.socialLogin(email, response);
	    if (bootTokenDTO == null) {

	        // redirectAfterLogin 값 보존
	        Object redirect = session.getAttribute("redirectAfterLogin");
	        if (redirect != null) {
	            session.setAttribute("pendingRedirectAfterJoin", redirect);
	        }
	        session.setAttribute("kakaoemail", email);
	        return "redirect:/auth/join/agree";
	    }
	    
	    MemberEntity memberEntity = MemberEntity.builder()
	    		.memberId(bootTokenDTO.getLogin().getId().intValue())
	    		.memberEmail(bootTokenDTO.getLogin().getEmail())
	    		.memberName(bootTokenDTO.getLogin().getName())
	    		.memberPhone(bootTokenDTO.getLogin().getPhone())
	    		.build();

	    session.setAttribute("loginMember", memberEntity);
	    log.info("email = {}", email);
	    log.info("accessToken = {}", accessToken);

	    String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
	    session.removeAttribute("redirectAfterLogin");
        model.addAttribute("accessToken", bootTokenDTO.getAccessToken());
	    model.addAttribute("autoLogin", true);
	    return "main/main";
	}

	@GetMapping("/naver")
	public String naver(@RequestParam("code") String code, HttpSession session, Model model, HttpServletResponse response) throws IOException {
	    String accessToken = naverService.getAccessTokenFromNaver(code, "test");
	    Map<String, Object> userInfo = naverService.getUserInfoFromNaver(accessToken);

	    String email = (String) userInfo.get("email");
	    BootTokenDTO bootTokenDTO = bootAPIUtil.socialLogin(email, response);
	    if (bootTokenDTO == null) {

	        // redirectAfterLogin 값 보존
	        Object redirect = session.getAttribute("redirectAfterLogin");
	        if (redirect != null) {
	            session.setAttribute("pendingRedirectAfterJoin", redirect);
	        }
	        
	        session.setAttribute("naverInfo", userInfo);
	        return "redirect:/auth/join/agree";
	    }

	    MemberEntity memberEntity = MemberEntity.builder()
	    		.memberId(bootTokenDTO.getLogin().getId().intValue())
	    		.memberEmail(bootTokenDTO.getLogin().getEmail())
	    		.memberName(bootTokenDTO.getLogin().getName())
	    		.memberPhone(bootTokenDTO.getLogin().getPhone())
	    		.build();

	    session.setAttribute("loginMember", memberEntity);
	    log.info("email = {}", email);
	    log.info("accessToken = {}", accessToken);

	    String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
	    session.removeAttribute("redirectAfterLogin");
        model.addAttribute("accessToken", bootTokenDTO.getAccessToken());
	    model.addAttribute("autoLogin", true);
	    return "main/main";
	}

}
