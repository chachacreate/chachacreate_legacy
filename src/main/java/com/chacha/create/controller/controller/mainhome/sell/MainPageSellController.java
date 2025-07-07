package com.chacha.create.controller.controller.mainhome.sell;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.service.mainhome.personal.PersonalInfoService;
import com.chacha.create.service.mainhome.personal.PersonalSettlementService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main/sell")
public class MainPageSellController {
	
	@Autowired
    private PersonalSettlementService personalSettlementService;

	@Autowired
	private PersonalInfoService personalInfoService;
    
	// 개인 판매 홈 ( /main/sell )
    @GetMapping("/sellguide")
    public String personalSellHome(HttpSession session, Model model) {
    	try {
	    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
	    	model.addAttribute("sellerCheck",personalInfoService.selectForSellerByMemberId(loginMember));
    	}catch(Exception e){
    		model.addAttribute("sellerCheck",false);
    	}
        return "main/personal/personalSellInfo";
    }

    // 개인 판매 상품 등록 ( /main/personalsell/register )
    @GetMapping("/sellregister")
    public String productRegister(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
    	try {
	    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
	    	if(!personalInfoService.selectForPersonalcheckByMemberId(loginMember)) {
	    		redirectAttributes.addFlashAttribute("message", "개인판매자가 아닙니다!");
	    		return "redirect:/main/sell/sellguide";
	    	}	
    	}catch(Exception e){
    		redirectAttributes.addFlashAttribute("message", "개인판매자가 아닙니다!");
    		return "redirect:/main/sell/sellguide";
    	}
        return "main/personal/saleRegistration";
    }

    // 개인 판매 상품 목록 ( /main/personalsell/products )
    @GetMapping("/products")
    public String productList(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
    	try {
	    	MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
	    	if(!personalInfoService.selectForPersonalcheckByMemberId(loginMember)) {
	    		redirectAttributes.addFlashAttribute("message", "개인판매자가 아닙니다!");
	    		return "redirect:/main/sell/sellguide";
	    	}	
    	}catch(Exception e){
    		redirectAttributes.addFlashAttribute("message", "개인판매자가 아닙니다!");
    		return "redirect:/main/sell/sellguide";
    	}
        return "main/personal/orderManage";
    }

    // 개인 판매 정산 페이지 ( /main/personalsell/settlement )
    @GetMapping("/management")
    public String settlementPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
    	MemberEntity loginMember = null;
    	try {
	    	loginMember = (MemberEntity) session.getAttribute("loginMember");
	    	if(!personalInfoService.selectForPersonalcheckByMemberId(loginMember)) {
	    		redirectAttributes.addFlashAttribute("message", "개인판매자가 아닙니다!");
	    		return "redirect:/main/sell/sellguide";
	    	}	
    	}catch(Exception e){
    		redirectAttributes.addFlashAttribute("message", "개인판매자가 아닙니다!");
    		return "redirect:/main/sell/sellguide";
    	}
    	List<Map<String, Object>> sellmanageList = personalSettlementService.sellManagement(loginMember);
    	Map<String, List<Map<String, Object>>> daySellmanagelist = personalSettlementService.daySellManagementByProduct(loginMember);
         
        model.addAttribute("sellmanageList", sellmanageList);
        model.addAttribute("daySellmanagelist", daySellmanagelist);
        
        log.info("로그인 사용자: {}", loginMember);
        log.info("sellmanageList: {}", sellmanageList);
        log.info("daySellmanagelist: {}", daySellmanagelist);

        return "main/personal/personalSettlement";
    }

}
