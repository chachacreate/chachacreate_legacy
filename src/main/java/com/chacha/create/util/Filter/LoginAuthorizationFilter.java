package com.chacha.create.util.Filter;

import java.io.IOException;
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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginAuthorizationFilter implements Filter {

	@Autowired
	private SellerMapper sellerMapper;
	@Autowired
	private StoreMapper storeMapper;

	// ✅ 로그인/권한 검사에서 제외할 URI 목록
	private static final Set<String> WHITELIST = new HashSet<>(
			Arrays.asList("/auth/", "/main/", "/chat/", "/api/", "/sendEmail", // 추가 필요
					"/resources/" // 정적 자원
			));

	@Override
	public void init(FilterConfig filterConfig) {
		WebApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(filterConfig.getServletContext());
		this.sellerMapper = ctx.getBean(SellerMapper.class);
		this.storeMapper = ctx.getBean(StoreMapper.class);
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String contextPath = req.getContextPath(); // ex: /create
		String uri = req.getRequestURI(); // ex: /create/main
		String relativeUri = uri.substring(contextPath.length()); // ex: /main
		// ✅ 화이트리스트 or /{storeUrl}/ 경로는 허용
		if (isWhitelisted(relativeUri) || isPublicStoreUrl(relativeUri)) {
			chain.doFilter(request, response);
			return;
		}

		HttpSession session = req.getSession(false);
		MemberEntity loginMember = (session != null) ? (MemberEntity) session.getAttribute("loginMember") : null;
		// 로그인 체크
		if (loginMember == null) {
			log.info("로그인이 필요합니다.");
			res.sendRedirect(req.getContextPath() + "/auth/login");
			return;
		}

		Integer memberId = loginMember.getMemberId();

		// /{storeUrl}/seller 하위 경로 - 해당 스토어 판매자만 접근
		if (relativeUri.matches("^/[^/]+/seller(/.*)?$")) {
			String[] parts = relativeUri.split("/");
			if (parts.length >= 2) {
				String storeUrl = parts[1];
				// log.info(storeUrl);
				StoreEntity store = storeMapper.selectByStoreUrl(storeUrl);
				if (store == null || !isStoreOwner(store, memberId)) {
					log.info("본인 스토어만 접속 가능합니다.");
					res.sendRedirect(req.getContextPath() + "/" + storeUrl);
					return;
				}
			}
		}

		// /manager 경로 - 관리자만 접근
		else if (relativeUri.startsWith("/manager")) {
			if (!memberId.equals(1)) {
				res.sendError(ResponseCode.FORBIDDEN.getStatus(), "관리자만 접근 가능합니다.");
				return;
			}
		}

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

	@Override
	public void destroy() {
	}
}