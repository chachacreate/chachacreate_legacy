package com.chacha.create.util.Filter;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.util.BootPathConfig;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginAuthorizationFilter implements Filter {

    private SellerMapper sellerMapper;
    private StoreMapper storeMapper;
	
	// ConfigUtil Bean 저장용 필드 추가
	private BootPathConfig configUtil;

	// ✅ 로그인/권한 검사에서 제외할 URI 목록
	private static final Set<String> WHITELIST = new HashSet<>(
			Arrays.asList("/auth/", "/main/", "/chat/", "/legacy/", "/resources/"));

	// ObjectMapper for JSON parsing
	private static final ObjectMapper objectMapper = new ObjectMapper();

	@Override
    public void init(FilterConfig filterConfig) {
        WebApplicationContext ctx = WebApplicationContextUtils
                .getRequiredWebApplicationContext(filterConfig.getServletContext());
        
        // 모든 Bean을 여기서 수동으로 가져오기
        this.sellerMapper = ctx.getBean(SellerMapper.class);
        this.storeMapper = ctx.getBean(StoreMapper.class);
        
        try {
            this.configUtil = ctx.getBean(BootPathConfig.class);
            log.debug("BootPathConfig Bean 조회 성공: {}", configUtil.getBootUrl());
        } catch (Exception e) {
            log.error("BootPathConfig Bean 조회 실패, 기본값 사용: {}", e.getMessage());
            this.configUtil = null;
        }
        
        log.debug("LoginAuthorizationFilter 초기화 완료");
    }

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String contextPath = req.getContextPath(); // ex: /create
		String uri = req.getRequestURI(); // ex: /create/main
		String relativeUri = uri.substring(contextPath.length()); // ex: /main
		
		log.debug("=== LoginAuthorizationFilter 실행 ===");
		log.debug("요청 URI: {}, 상대 URI: {}", uri, relativeUri);
		log.debug("Authorization 헤더: {}", req.getHeader("Authorization"));
		
		// ✅ 화이트리스트 or /{storeUrl}/ 경로는 허용
		if (isWhitelisted(relativeUri) || isPublicStoreUrl(relativeUri)) {
			log.debug("화이트리스트 경로 - 인증 패스: {}", relativeUri);
			chain.doFilter(request, response);
			return;
		}

		// JWT 토큰 확인 (우선순위)
		String authorization = req.getHeader("Authorization");
		MemberEntity loginMember = null;
		
		if (authorization != null && authorization.startsWith("Bearer ")) {
			log.debug("JWT 토큰 발견, 검증 시도");
			loginMember = validateTokenWithSpringBoot(authorization);
		}
		
		// 세션 기반 로그인 확인 (fallback)
		if (loginMember == null) {
			log.debug("JWT 토큰 없음 또는 유효하지 않음, 세션 확인");
			HttpSession session = req.getSession(false);
			loginMember = (session != null) ? (MemberEntity) session.getAttribute("loginMember") : null;
			
			if (loginMember != null) {
				log.debug("세션에서 로그인 회원 발견: {}", loginMember.getMemberId());
			}
		}
		
		// 로그인 체크
		if (loginMember == null) {
			log.debug("로그인이 필요합니다. URI: {}", relativeUri);
			res.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		log.debug("인증된 사용자: 회원ID={}", loginMember.getMemberId());
		Integer memberId = loginMember.getMemberId();

		// /{storeUrl}/seller 하위 경로 - 해당 스토어 판매자만 접근
		if (relativeUri.matches("^/[^/]+/seller(/.*)?$")) {
			String[] parts = relativeUri.split("/");
			if (parts.length >= 2) {
				String storeUrl = parts[1];
				log.debug("스토어 접근 권한 확인: storeUrl={}, memberId={}", storeUrl, memberId);
				
				StoreEntity store = storeMapper.selectByStoreUrl(storeUrl);
				if (store == null || !isStoreOwner(store, memberId)) {
					log.warn("스토어 접근 권한 없음: storeUrl={}, memberId={}", storeUrl, memberId);
					res.sendRedirect(req.getContextPath() + "/" + storeUrl);
					return;
				}
				log.debug("스토어 접근 권한 확인됨: storeUrl={}", storeUrl);
			}
		}

		// /manager 경로 - 관리자만 접근
		else if (relativeUri.startsWith("/manager")) {
			if (!isAdmin(loginMember)) {
				log.warn("관리자 권한 없음: memberId={}, role={}", 
					loginMember.getMemberId(), loginMember.getMemberRole());
				res.sendError(ResponseCode.FORBIDDEN.getStatus(), "관리자만 접근 가능합니다.");
				return;
			}
			log.debug("관리자 접근 권한 확인됨: memberId={}", loginMember.getMemberId());
		}

		log.debug("=== 필터 통과, 다음 체인으로 진행 ===");
		chain.doFilter(request, response);
	}

	// ✅ 정적 자원 및 일반 화이트리스트 경로
	private boolean isWhitelisted(String uri) {
		for (String path : WHITELIST) {
			if (uri.startsWith(path) && !uri.startsWith(path + "mypage")) {
				return true;
			}
		}
		return false;
	}

	// ✅ /{storeUrl}/ (예: /nike/) 패턴만 허용
	private boolean isPublicStoreUrl(String uri) {
		// ex) /nike/ 또는 /kakao
		return uri.matches("^/[^/]+/?$");
	}

	// ✅ 스토어 주인인 경우에만 허용
	private boolean isStoreOwner(StoreEntity store, Integer memberId) {
		SellerEntity seller = sellerMapper.selectBySellerId(store.getSellerId());
		return seller != null && seller.getMemberId().equals(memberId);
	}

	/**
	 * ConfigUtil Bean을 늦은 초기화로 조회
	 * @return ConfigUtil Bean 또는 null
	 */
	private BootPathConfig getConfigUtil() {
		// configUtil이 이미 있으면 반환
		return configUtil;
	}

	/**
	 * Spring Boot API를 통한 JWT 토큰 검증
	 * @param authorization Bearer 토큰
	 * @return MemberEntity 검증 성공 시 회원 정보, 실패 시 null
	 */
	private MemberEntity validateTokenWithSpringBoot(String authorization) {
		HttpURLConnection conn = null;
		try {
			// 늦은 초기화로 configUtil 조회
			BootPathConfig config = getConfigUtil();
			String validateUrl = (config != null) 
				? config.getTokenValidateUrl() 
				: "http://localhost:8888/api/auth/validate";
				
			log.debug("토큰 검증 요청: {}", validateUrl);
			
			URL url = new URL(validateUrl);
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", authorization);
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setConnectTimeout(5000); // 5초 타임아웃
			conn.setReadTimeout(5000);
			
			int responseCode = conn.getResponseCode();
			log.debug("토큰 검증 응답 코드: {}", responseCode);
			
			if (responseCode == 200) {
				// JSON 응답 읽기
				StringBuilder response = new StringBuilder();
				try (BufferedReader reader = new BufferedReader(
						new InputStreamReader(conn.getInputStream()))) {
					String line;
					while ((line = reader.readLine()) != null) {
						response.append(line);
					}
				}
				
				String jsonResponse = response.toString();
				log.debug("토큰 검증 응답: {}", jsonResponse);
				
				// JSON 파싱하여 MemberEntity 생성
				return parseMemberFromResponse(jsonResponse);
			} else {
				log.debug("토큰 검증 실패: HTTP {}", responseCode);
			}
		} catch (Exception e) {
			log.error("토큰 검증 중 오류 발생", e);
		} finally {
			if (conn != null) {
				conn.disconnect();
			}
		}
		return null;
	}

	/**
	 * JSON 응답을 MemberEntity로 변환
	 * @param jsonResponse Spring Boot API 응답 JSON
	 * @return MemberEntity 변환된 회원 정보
	 */
	private MemberEntity parseMemberFromResponse(String jsonResponse) {
		try {
			JsonNode jsonNode = objectMapper.readTree(jsonResponse);
			
			// JSON에서 필요한 정보 추출 (Long 타입으로 수정)
			Long memberId = jsonNode.get("memberId").asLong();
			String username = jsonNode.get("username").asText();
			
			// memberRole 처리 (enum이므로 문자열로 받아서 처리)
			String memberRoleStr = jsonNode.has("memberRole") ? 
				jsonNode.get("memberRole").asText() : null;
			
			log.debug("파싱된 회원 정보: memberId={}, username={}, role={}", 
				memberId, username, memberRoleStr);
			
			// MemberEntity 생성 (필요한 필드만 설정)
			// 주의: 레거시 시스템의 MemberEntity 구조에 맞게 수정 필요
			MemberEntity member = new MemberEntity();
			// 레거시 시스템에서 memberId가 Integer 타입일 수 있으므로 변환
			member.setMemberId(memberId.intValue()); // 또는 적절한 setter 메서드 사용
			member.setMemberEmail(username);
			
			// 권한 정보 저장 (레거시 필터에서 권한 체크용)
			member.setMemberRole(memberRoleStr); // 레거시 MemberEntity에 role 필드 추가함
			
			return member;
		} catch (Exception e) {
			log.error("JSON 파싱 실패: {}", jsonResponse, e);
			return null;
		}
	}

	/**
	 * 관리자 권한 체크 (역할 기반)
	 * @param member 회원 정보
	 * @return boolean 관리자면 true
	 */
	private boolean isAdmin(MemberEntity member) {
		if (member == null) {
			return false;
		}
		
		// 역할 기반 체크 (Spring Boot에서 받은 정보)
		String memberRole = member.getMemberRole(); // 레거시 MemberEntity에 getMemberRole() 메서드가 있다면
		if (memberRole != null && "ADMIN".equals(memberRole)) {
			return true;
		}
		return false;
	}

	@Override
	public void destroy() {
		log.debug("LoginAuthorizationFilter 종료");
	}
}