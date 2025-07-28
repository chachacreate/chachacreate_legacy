package com.chacha.create.util.Filter;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FilterConfig {

    // loginAuthorizationFilter를 수동 Bean 등록
    @Bean(name = "loginFilter")
    public LoginAuthorizationFilter loginAuthorizationFilter() {
        return new LoginAuthorizationFilter();
    }

}
