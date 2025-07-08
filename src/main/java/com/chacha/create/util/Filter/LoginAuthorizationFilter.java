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

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

public class LoginAuthorizationFilter implements Filter {

    private SellerMapper sellerMapper;
    private StoreMapper storeMapper;

    // ✅ 로그인/권한 검사에서 제외할 URI 목록
    private static final Set<String> WHITELIST = new HashSet<>(Arrays.asList(
        "/auth/", "/main/", "/chat/", "/api/", "/sendEmail", // 추가 필요
        "/resources/" // 정적 자원
    ));
    
    public LoginAuthorizationFilter(SellerMapper sellerMapper, StoreMapper storeMapper) {
        this.sellerMapper = sellerMapper;
        this.storeMapper = storeMapper;
    }

    @Override
    public void init(FilterConfig filterConfig) { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        MemberEntity loginMember = (session != null) ? (MemberEntity) session.getAttribute("loginMember") : null;

        // ✅ 화이트리스트 or /{storeUrl}/ 경로는 허용
        if (isWhitelisted(uri) || isPublicStoreUrl(uri)) {
            chain.doFilter(request, response);
            return;
        }

        // 로그인 체크
        if (loginMember == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        Integer memberId = loginMember.getMemberId();

        // /{storeUrl}/seller 하위 경로 - 해당 스토어 판매자만 접근
        if (uri.matches("^/[^/]+/seller(/.*)?$")) {
            String[] parts = uri.split("/");
            if (parts.length >= 2) {
                String storeUrl = parts[1];
                StoreEntity store = storeMapper.selectByStoreUrl(storeUrl);
                if (store == null || !isStoreOwner(store, memberId)) {
                    res.sendError(ResponseCode.FORBIDDEN.getStatus(), "해당 스토어의 판매자만 접근 가능합니다.");
                    return;
                }
            }
        }

        // /manager 경로 - 관리자만 접근
        else if (uri.startsWith("/manager")) {
            if (!memberId.equals(1)) {
                res.sendError(ResponseCode.FORBIDDEN.getStatus(), "관리자만 접근 가능합니다.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    // ✅ 정적 자원 및 일반 화이트리스트 경로
    private boolean isWhitelisted(String uri) {
        return WHITELIST.stream().anyMatch(uri::equals) ||
               WHITELIST.stream().anyMatch(uri::startsWith);
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
	public void destroy() {	}
}