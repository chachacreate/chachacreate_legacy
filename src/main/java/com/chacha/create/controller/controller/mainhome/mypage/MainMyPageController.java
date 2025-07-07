package com.chacha.create.controller.controller.mainhome.mypage;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

// 리뷰 오류

@Slf4j
@Controller
@RequestMapping("main/mypage")
public class MainMyPageController {

    
    @GetMapping("/cart")
    public String showCartPage() {
		return "store/buyer/mypage/cart";
    }
    
    @GetMapping("/orders")
    public String showOrdersPage() {
		return "main/mypage/mainMyPageOrderList";
    }
    
    @GetMapping("/orderdetail/{orderId}")
    public String showOrderDetailPage(@PathVariable Integer orderId, Model model) {
    	model.addAttribute("orderId", orderId);
    	return "store/buyer/mypage/orderDetail";
    }
    
    @GetMapping("/favorite")
    public String showFavoritePage() {
		return "";
    }
    
    @GetMapping("/message")
    public String showMessagePage(@RequestParam(required = false) String storeUrl, Model model) {
    	model.addAttribute("storeUrl", storeUrl);
    	return "main/mypage/chat";
    }
    
    @GetMapping("/myreview")
    public String showReviewPage() {
		return "main/mypage/mainMyPageReview";
    }
    
    
}
