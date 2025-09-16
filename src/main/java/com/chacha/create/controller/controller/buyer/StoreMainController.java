package com.chacha.create.controller.controller.buyer;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.chacha.create.common.dto.member.SellerInfoDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.service.buyer.storeinfo.StoreInfoService;
import com.chacha.create.service.mainhome.store.StoreService;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/{storeUrl}")
@RequiredArgsConstructor
public class StoreMainController {
	
	private final StoreInfoService storeinfo;
	private final StoreService storeService;
	private final S3Uploader s3Uploader;
	
	public void setStoreNavInfo(String storeUrl, Model model) {
		StoreInfoDTO storeInfo = storeinfo.selectForThisStoreInfo(storeUrl);
		log.info(storeInfo.toString());
		model.addAttribute("storeUrl",storeUrl);
		model.addAttribute("logoImg", s3Uploader.getThumbnailUrlByFullUrl(storeInfo.getLogoImg()));
		model.addAttribute("storeOwnerId", storeInfo.getMemberId());
		model.addAttribute("storeName", storeInfo.getStoreName());
	}
	
	// 스토어 구매자 메인페이지
	@GetMapping
	public String ShowstoreMain(@PathVariable String storeUrl, Model model, HttpSession session) {
		session.removeAttribute("kakaoemail");
		session.removeAttribute("naverInfo");
		session.removeAttribute("makeChat");
		if(!storeService.existsByStoreUrl(storeUrl)) {
			return "redirect:/main";
		}
		setStoreNavInfo(storeUrl, model);
		return "store/storeMain";
	}
	
	// 상세페이지
	@GetMapping("/productdetail/{productId}")
	public String ShowProductdetail(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/productDetail";
	}

	// 결제 페이지
	@GetMapping("/order")
	public String ShowOrder(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/buyer/order";
	}
	
	// 결제 완료페이지
	@GetMapping("/order/complete/{orderId}")
	public String ShowOrderComplete(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/buyer/orderComplete";
	}
	
	// 전체 상품
	@GetMapping("/products")
	public String ShowstoreAllProduct(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/storeAllProducts";
	}
	
	// 문의 메시지
	@GetMapping("/message")
	public String ShowMessage(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/chat";
	}

	// 스토어 소개/판매자 정보
	//{storeUrl}/info
	@GetMapping("/info")
	public String ShowSeller_info(@PathVariable("storeUrl") String storeUrl, Model model) {

		List<StoreEntity> storeInfoList = storeinfo.selectByStoreInfo(storeUrl);
        List<SellerInfoDTO> sellerInfoList = storeinfo.selectBySellerInfo(storeUrl);
        if (storeInfoList != null && !storeInfoList.isEmpty()) {
            model.addAttribute("storeInfoList", storeInfoList.get(0));
        }

        if (sellerInfoList != null && !sellerInfoList.isEmpty()) {
            model.addAttribute("sellerInfoList", sellerInfoList.get(0));
        }
        
        setStoreNavInfo(storeUrl, model);
		return "store/storeInfo";
	}
	
	// 공지사항
	@GetMapping("/notices")
	public String ShowNotices(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/storeNotice";
	}
	
	// 공지사항 상세
	@GetMapping("/noticedetail")
	public String ShowNoticedetail(@PathVariable String storeUrl, @RequestParam int noticeId, Model model) {
		setStoreNavInfo(storeUrl, model);
		model.addAttribute("noticeId",noticeId);
		return "main/mainNotice";
	}

}
