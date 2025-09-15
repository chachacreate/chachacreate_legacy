package com.chacha.create.controller.controller.error;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/error")
public class ErrorController {
	@GetMapping("/400")
	public String error400() {
		return "error/error400";
	}
	
	@GetMapping("/401")
	public String error401() {
		return "error/error401";
	}
	
	@GetMapping("/404")
	public String error404() {
		return "error/error404";
	}
	
	@GetMapping("/500")
	public String error500() {
		return "error/error500";
	}
}
