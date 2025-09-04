package com.chacha.create.util.Filter;

import java.io.IOException;
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

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.chacha.create.util.BootPathConfig;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CorsResponseHeaderFilter implements Filter {
    
    private BootPathConfig bootPathConfig;
    private Set<String> allowedOrigins;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.debug("=== CorsResponseHeaderFilter init() 시작 ===");
        log.debug("FilterConfig: {}", filterConfig);
        
        try {
            WebApplicationContext ctx = WebApplicationContextUtils
                    .getRequiredWebApplicationContext(filterConfig.getServletContext());
            log.debug("WebApplicationContext 조회 성공: {}", ctx);
            
            this.bootPathConfig = ctx.getBean(BootPathConfig.class);
            log.debug("BootPathConfig Bean 조회 성공: {}", bootPathConfig);
            
            // CORS 설정 즉시 초기화
            Set<String> configOrigins = bootPathConfig.getCorsAllowedOrigins();
            log.debug("설정에서 가져온 Origins: {}", configOrigins);
            
            if (configOrigins != null && !configOrigins.isEmpty()) {
                this.allowedOrigins = configOrigins;
                log.debug("설정 파일에서 CORS 허용 Origin 로드 성공: {}", allowedOrigins);
            } else {
                this.allowedOrigins = getDefaultAllowedOrigins();
                log.debug("설정 파일에 CORS Origin이 없거나 비어있음, 기본값 사용: {}", allowedOrigins);
            }
            
        } catch (Exception e) {
            log.error("=== init() 메서드에서 예외 발생 ===", e);
            log.error("BootPathConfig Bean 조회 실패, 기본값 사용: {}", e.getMessage());
            this.bootPathConfig = null;
            this.allowedOrigins = getDefaultAllowedOrigins();
        }
        
        log.debug("=== CorsResponseHeaderFilter init() 완료, allowedOrigins: {} ===", allowedOrigins);
    }
    
    /**
     * 기본 허용 Origin 목록 반환
     */
    private Set<String> getDefaultAllowedOrigins() {
        Set<String> defaultOrigins = new HashSet<>();
        defaultOrigins.add("http://localhost:3000");
        defaultOrigins.add("http://localhost:5173");
        defaultOrigins.add("http://localhost:9999");
        defaultOrigins.add("http://localhost:8888");
        return defaultOrigins;
    }
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        
        String origin = request.getHeader("Origin");
        String method = request.getMethod();
        
        // 안전장치
        if (allowedOrigins == null) {
            log.warn("allowedOrigins가 null입니다. 기본값으로 초기화합니다.");
            allowedOrigins = getDefaultAllowedOrigins();
        }
        
        log.debug("=== CORS 필터 실행 ===");
        log.debug("요청 Method: {}", method);
        log.debug("요청 Origin: '{}'", origin);
        log.debug("허용 목록: {}", allowedOrigins);
        
        // Origin 매칭 상세 로그
        if (origin != null) {
            boolean isAllowed = allowedOrigins.contains(origin);
            log.debug("Origin '{}' 매칭 결과: {}", origin, isAllowed);
            
            if (isAllowed) {
                response.setHeader("Access-Control-Allow-Origin", origin);
                log.debug("CORS 허용된 Origin 헤더 설정: {}", origin);
            } else {
                log.warn("CORS 허용되지 않은 Origin: '{}', 허용목록: {}", origin, allowedOrigins);
            }
        } else {
            log.debug("Origin 헤더가 없음");
        }
        
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Origin, Content-Type, Accept, Authorization");
        response.setHeader("Access-Control-Expose-Headers", "Authorization");
        
        log.debug("CORS 응답 헤더 설정 완료");
        
        if ("OPTIONS".equalsIgnoreCase(method)) {
            log.debug("OPTIONS 요청 - 즉시 200 응답");
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        
        log.debug("=== CORS 필터 통과 ===");
        chain.doFilter(req, res);
    }
    
    @Override
    public void destroy() {
        log.debug("CorsResponseHeaderFilter 종료");
    }
}