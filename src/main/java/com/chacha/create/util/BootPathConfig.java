package com.chacha.create.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource(value = {"classpath:git_submodule_chacha/application-common.properties"})
public class BootPathConfig {

	@Value("${spring.boot.api.url}")
	private String springBootApiUrl;

	@Value("${spring.legacy.api.url}")
	private String springLegacyApiUrl;

	@Bean
	public String getBootUrl() {
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
