package com.chacha.create.util.Filter;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
public class FilterConfig {
    
    @Bean(name = "loginFilter")
    public LoginAuthorizationFilter loginAuthorizationFilter() {
        log.debug("LoginAuthorizationFilter Bean 생성됨");
        return new LoginAuthorizationFilter();
    }
    
    @Bean(name = "corsFilter")
    public CorsResponseHeaderFilter corsResponseHeaderFilter() {
        log.debug("CorsResponseHeaderFilter Bean 생성됨");
        return new CorsResponseHeaderFilter();
    }
}