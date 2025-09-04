package com.chacha.create.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@Slf4j
@Component
@Configuration
@PropertySource(value = {"classpath:git_submodule_chacha/application-common.properties"})
public class BootPathConfig {
    
    @Value("${spring.boot.api.url}")
    private String springBootApiUrl;
    
    @Value("${spring.legacy.api.url}")
    private String springLegacyApiUrl;
    
    @Value("${app.cors.allowed-origins}")
    private String corsAllowedOrigins;
    
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
    
    @Bean
    public String getBootUrl() {
        return springBootApiUrl;
    }
    
    public String getTokenValidateUrl() {
        return springBootApiUrl + "/auth/validate";
    }
    
    public String getTokenCheckUrl() {
        return springBootApiUrl + "/auth/check";
    }
    
    /**
     * CORS 허용 Origin 목록 조회
     * @return Set<String> 허용된 Origin 목록
     */
    public Set<String> getCorsAllowedOrigins() {
        log.debug("corsAllowedOrigins 원본 값: '{}'", corsAllowedOrigins);
        
        if (corsAllowedOrigins == null || corsAllowedOrigins.trim().isEmpty()) {
            log.debug("corsAllowedOrigins가 null이거나 비어있음, 빈 Set 반환");
            return new HashSet<>();
        }
        
        try {
            // 쉼표로 구분된 문자열을 Set으로 변환 (공백 제거)
            Set<String> origins = Arrays.stream(corsAllowedOrigins.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty()) // 빈 문자열 제거
                    .collect(java.util.stream.Collectors.toSet());
            
            log.debug("파싱된 CORS Origins: {}", origins);
            return origins;
            
        } catch (Exception e) {
            log.error("CORS Origin 파싱 실패: '{}'", corsAllowedOrigins, e);
            return new HashSet<>();
        }
    }
}