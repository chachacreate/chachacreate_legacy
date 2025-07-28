package com.chacha.create.controller.controller.manager.store;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/manager")
public class StoreManageController {
	
	@GetMapping("/stores")
	public String storemanage() {
		return "admin/storeManage";
	}

}
