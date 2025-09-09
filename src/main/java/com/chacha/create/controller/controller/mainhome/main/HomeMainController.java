package com.chacha.create.controller.controller.mainhome.main;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/main")
public class HomeMainController {
	
    // 메인 홈 페이지
    @GetMapping
    public String showMainHome(HttpSession session) {
		session.removeAttribute("kakaoemail");
		session.removeAttribute("naverInfo");
		session.removeAttribute("makeChat");
        return "main/main"; 
    }
    
    
    @GetMapping("/products")
    public String showAllproductsPage() {
		return "main/mainAllProducts";
    }
    
	// 상세페이지
	@GetMapping("/products/{productId}")
	public String showProductdetail() {
		return "store/productDetail";
	}
    
    
    @GetMapping("/question")
    public String showNoticePage() {
		return "main/mainNotice";
    }
    
    
    @GetMapping("/mypage")
    public String showMyPage() {
    	return "main/mypage/mainMyPage";
    }
    
    @GetMapping("/order")
    public String showOrderPage() {
    	return "store/buyer/order";
    }
    
	// 결제 완료페이지
	@GetMapping("/order/complete/{orderId}")
	public String ShowOrderComplete() {
		return "store/buyer/orderComplete";
	}
 
}
