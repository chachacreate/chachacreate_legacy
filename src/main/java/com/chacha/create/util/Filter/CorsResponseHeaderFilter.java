package com.chacha.create.util.Filter;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

import javax.servlet.*;
import javax.servlet.FilterConfig;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@Component
public class CorsResponseHeaderFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String origin = request.getHeader("Origin");
        String requestURI = request.getRequestURI();

        
        if (requestURI.endsWith("/auth/kakao") || requestURI.endsWith("/auth/naver")) {
            if ("http://chachacreate.dustbox.kr".equals(origin)) {
            	log.info("카카오로그인 헤더 추가 중~~~");
                response.setHeader("Access-Control-Allow-Origin", origin);
                response.setHeader("Access-Control-Allow-Credentials", "true");
                response.setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS");
                response.setHeader("Access-Control-Allow-Headers", "Origin, Content-Type, Accept, Authorization");
                response.setHeader("Access-Control-Expose-Headers", "Authorization");
            }

            // 프리플라이트 OPTIONS 요청일 경우 조기 반환
            if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204 응답
                return;
            }
        }

        chain.doFilter(req, res);
    }

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}
}
