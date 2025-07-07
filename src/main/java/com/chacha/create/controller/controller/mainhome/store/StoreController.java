package com.chacha.create.controller.controller.mainhome.store;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.service.mainhome.personal.PersonalInfoService;
import com.chacha.create.service.mainhome.store.StoreService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("main/store")
public class StoreController {
	
	@Autowired
	private StoreService storeService;
    
	@Autowired
	private PersonalInfoService personalInfoService;
	
	@GetMapping("/stores")
    public String showAllStoresPage() {
		return "main/mainStoreList";
    }
	
	@GetMapping("/description")
    public String showStoreInfoPage(HttpSession session, Model model) {
    	try {
	    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
	    	model.addAttribute("personalCheck",personalInfoService.selectForPersonalcheckByMemberId(loginMember));
    	}catch(Exception e){
    		model.addAttribute("personalCheck",false);
    	}
		return "main/mainStoreInfo";
    }

	@GetMapping("/openform")
	public String showStoreOpenPage(HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		if(loginMember == null || storeService.checkNotCreateable(loginMember)) {
			String message = "스토어 개설을 할 수 없습니다! 개인판매자 등록을 해주세요.";
			log.info(message);
			session.setAttribute("fail", message);
			return "redirect:/main/sell/sellguide";
		}
		if(storeService.checkProductCount(loginMember)) {
			String message = "상품이 2개 등록되어야 있어야 가능합니다!";
			log.info(message);
			session.setAttribute("fail", message);
			return "redirect:/main/sell/sellguide";
		}
			return "main/sellerJoin";
	}
}
