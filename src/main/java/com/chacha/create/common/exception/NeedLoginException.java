package com.chacha.create.common.exception;

public class NeedLoginException extends RuntimeException {
    public NeedLoginException(String message) {
        super(message);
    }
}
