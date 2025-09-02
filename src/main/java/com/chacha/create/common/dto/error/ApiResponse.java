package com.chacha.create.common.dto.error;

import com.chacha.create.common.enums.error.ResponseCode;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class ApiResponse<T> {
    private int status;
    private String message;
    private T data;
    
	public ApiResponse(ResponseCode responseCode, String message) {
		this.status = responseCode.getStatus();
		this.message = message;
	}
    
    public ApiResponse(ResponseCode code, T data) {
        this.status = code.getStatus();
        this.message = code.getMessage();
        this.data = data;
    }
    
    public ApiResponse(ResponseCode code, String message, T data) {
    	this.status = code.getStatus();
    	this.message = code.getMessage();
    	this.data = data;
    }
}
