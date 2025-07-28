package com.chacha.create.controller.controller.manager.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/manager")
public class MemberManagementController {
	
	@GetMapping("/users")
	public String membermanage() {
		return "admin/memberManage";
	}
}
