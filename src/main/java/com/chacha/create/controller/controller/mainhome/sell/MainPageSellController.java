package com.chacha.create.controller.controller.mainhome.sell;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.service.mainhome.personal.PersonalSettlementService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main/sell")
public class MainPageSellController {
	
	@Autowired
    private PersonalSettlementService personalSettlementService;

    
	// 개인 판매 홈 ( /main/sell )
    @GetMapping("sellguide")
    public String personalSellHome() {
        return "main/personal/personalSellInfo";
    }

    // 개인 판매 상품 등록 ( /main/personalsell/register )
    @GetMapping("/sellregister")
    public String productRegister() {
        return "main/personal/saleRegistration";
    }

    // 개인 판매 상품 목록 ( /main/personalsell/products )
    @GetMapping("/products")
    public String productList() {
        return "main/personal/orderManage";
    }

    // 개인 판매 정산 페이지 ( /main/personalsell/settlement )
    @GetMapping("/management")
    public String settlementPage(HttpSession session, Model model) {
    	
    	MemberEntity member = (MemberEntity) session.getAttribute("loginMember");

    	List<Map<String, Object>> sellmanageList = personalSettlementService.sellManagement(member);
    	Map<String, List<Map<String, Object>>> daySellmanagelist = personalSettlementService.daySellManagementByProduct(member);
         
        model.addAttribute("sellmanageList", sellmanageList);
        model.addAttribute("daySellmanagelist", daySellmanagelist);
        
        log.info("로그인 사용자: {}", member);
        log.info("sellmanageList: {}", sellmanageList);
        log.info("daySellmanagelist: {}", daySellmanagelist);

        return "main/personal/personalSettlement";
    }
}
