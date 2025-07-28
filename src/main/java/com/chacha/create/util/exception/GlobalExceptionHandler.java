package com.chacha.create.util.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.common.exception.LoginFailException;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.exception.SessionExpiredException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(InvalidRequestException.class)
    public ResponseEntity<ApiResponse<Void>> handleInvalidRequest(InvalidRequestException e) {
        log.warn("Invalid request: {}", e.getMessage());
        e.printStackTrace();
        return ResponseEntity
                .status(ResponseCode.BAD_REQUEST.getStatus())
                .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, null));
    }

    @ExceptionHandler(LoginFailException.class)
    public ResponseEntity<ApiResponse<Void>> handleLoginFail(LoginFailException e) {
        log.warn("Login failed: {}", e.getMessage());
        e.printStackTrace();
        return ResponseEntity
                .status(ResponseCode.LOGIN_FAIL.getStatus())
                .body(new ApiResponse<>(ResponseCode.LOGIN_FAIL, null));
    }
    
    @ExceptionHandler(NeedLoginException.class)
    public ResponseEntity<ApiResponse<Void>> handleNeedLogin(NeedLoginException e) {
    	log.warn("Need Login: {}", e.getMessage());
    	e.printStackTrace();
    	return ResponseEntity
    			.status(ResponseCode.UNAUTHORIZED.getStatus())
    			.body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, null));
    }

    @ExceptionHandler(SessionExpiredException.class)
    public ResponseEntity<ApiResponse<Void>> handleSessionExpired(SessionExpiredException e) {
        log.info("Session expired: {}", e.getMessage());
        e.printStackTrace();
        return ResponseEntity
                .status(ResponseCode.SESSION_EXPIRED.getStatus())
                .body(new ApiResponse<>(ResponseCode.SESSION_EXPIRED, null));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ApiResponse<Void>> handleIllegalState(IllegalStateException e) {
        log.error("IllegalStateException: {}", e.getMessage(), e);
        e.printStackTrace();
        return ResponseEntity
                .status(ResponseCode.BAD_REQUEST.getStatus())
                .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, null));
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<Void>> handleRuntime(RuntimeException e) {
        log.error("RuntimeException: {}", e.getMessage(), e);
        e.printStackTrace();
        return ResponseEntity
                .status(ResponseCode.INTERNAL_SERVER_ERROR.getStatus())
                .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, null));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(Exception e) {
        log.error("Unhandled exception: {}", e.getMessage(), e);
        e.printStackTrace();
        return ResponseEntity
                .status(ResponseCode.INTERNAL_SERVER_ERROR.getStatus())
                .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, null));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<String>> handleIllegalArgument(IllegalArgumentException e) {
    	e.printStackTrace();
        return ResponseEntity.badRequest()
            .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, e.getMessage()));
    }

    @ExceptionHandler(NullPointerException.class)
    public ResponseEntity<ApiResponse<String>> handleNullPointer(NullPointerException e) {
    	e.printStackTrace();
        return ResponseEntity.status(ResponseCode.INTERNAL_SERVER_ERROR.getStatus())
            .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, "널 포인터 예외 발생"));
    }
}
