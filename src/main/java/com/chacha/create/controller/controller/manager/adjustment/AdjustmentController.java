package com.chacha.create.controller.controller.manager.adjustment;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/manager/adjustment")
public class AdjustmentController {

	@GetMapping("/store")
	public String storeadjustment() {
		return "admin/storeSettlementManage";
	}
	
	@GetMapping("/seller")
	public String selleradjustment() {
		return "admin/personalSettlementManage";
	}
}
