package com.chacha.create.util.Filter;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LoginAuthorizationConfig {
    
    @Value("${spring.boot.api.url}")
    private String springBootApiUrl;
    
    /**
     * Spring Boot API URL 조회
     * @return String Spring Boot API 기본 URL
     */
    public String getSpringBootApiUrl() {
        return springBootApiUrl;
    }
    
    /**
     * Spring Boot 토큰 검증 URL 조회
     * @return String 토큰 검증 전체 URL
     */
    public String getTokenValidateUrl() {
        return springBootApiUrl + "/auth/validate";
    }
    
    /**
     * Spring Boot 토큰 체크 URL 조회
     * @return String 토큰 체크 전체 URL
     */
    public String getTokenCheckUrl() {
        return springBootApiUrl + "/auth/check";
    }
}
