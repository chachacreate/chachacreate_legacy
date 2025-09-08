package com.chacha.create.util.exception;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.NoHandlerFoundException;

import com.chacha.create.common.exception.LoginFailException;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.util.BootPathConfig;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class ExceptionAdvice {

//// Nginx 환경에서는 필요 없음
//	@Autowired
//	BootPathConfig bootpath;
//
//	@ModelAttribute("springBootApiUrl")
//	public String addApiUrls(Model model) {
//		return bootpath.getBootUrl();
//	}

	// 404 에러 처리
	@ExceptionHandler(NoHandlerFoundException.class)
	public String exception404(HttpServletRequest request, NoHandlerFoundException e) {
		log.warn("404 Not Found: URL = {}", request.getRequestURI(), e);
		return "error/error404";
	}

	// 500 내부 서버 에러 처리
	@ExceptionHandler(Exception.class)
	public String exception500(HttpServletRequest request, Exception e) {
		log.error("500 Internal Server Error: URL = {}", request.getRequestURI(), e);
		return "error/error500";
	}

	// 400 잘못된 요청 처리
	@ExceptionHandler(IllegalArgumentException.class)
	public String exception400(HttpServletRequest request, IllegalArgumentException e) {
		log.warn("400 Bad Request: URL = {}", request.getRequestURI(), e);
		return "error/error400";
	}

	// 401 인증 실패 처리
	@ExceptionHandler({ LoginFailException.class, NeedLoginException.class })
	public String exception401(HttpServletRequest request, RuntimeException e) {
		log.warn("401 Unauthorized: URL = {}", request.getRequestURI(), e);
		return "error/error401";
	}
}
