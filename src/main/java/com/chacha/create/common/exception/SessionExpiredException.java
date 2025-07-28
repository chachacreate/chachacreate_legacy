package com.chacha.create.common.exception;

public class SessionExpiredException extends RuntimeException {
    public SessionExpiredException() {
        super("세션이 만료되었거나 로그인되지 않았습니다.");
    }
}
