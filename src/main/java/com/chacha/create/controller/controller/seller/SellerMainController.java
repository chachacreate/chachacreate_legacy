package com.chacha.create.controller.controller.seller;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.dto.order.OrderSumDTO;
import com.chacha.create.common.dto.product.ProductUpdateDTO;
import com.chacha.create.common.dto.product.ProductWithImagesDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;
import com.chacha.create.common.dto.product.ReviewManagementDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.entity.product.ProductEntity;
import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.common.exception.LoginFailException;
import com.chacha.create.service.buyer.detail.ReviewService;
import com.chacha.create.service.buyer.storeinfo.StoreInfoService;
import com.chacha.create.service.seller.main.SellerMainService;
import com.chacha.create.service.seller.order.OrderManagementService;
import com.chacha.create.service.seller.product.ProductService;
import com.chacha.create.service.seller.shut_down.ShutDownService;
import com.chacha.create.service.store_common.header.auth.LoginService;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

// productDetail 오류

@Slf4j
@Controller
@RequestMapping("/{storeUrl}/seller")
@RequiredArgsConstructor
public class SellerMainController {
	
	
	private final ProductService productService;
	 
	private final SellerMainService sell;
	
	private final OrderManagementService omService;
	
	private final StoreInfoService storeinfo;
	
	private final LoginService loginService;
	
	private final ShutDownService shutdownService;
	
	private final ReviewService reviewService;

	
	public void setStoreNavInfo(String storeUrl, Model model) {
		StoreInfoDTO storeInfo = storeinfo.selectForThisStoreInfo(storeUrl);
		log.info(storeInfo.toString());
		model.addAttribute("storeUrl",storeUrl);
		model.addAttribute("logoImg", storeInfo.getLogoImg());
		model.addAttribute("storeOwnerId", storeInfo.getMemberId());
		model.addAttribute("storeName", storeInfo.getStoreName());
	}
	
	// 판매자 메인페이지
	@GetMapping("/main")
	public String showMainPage(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);

		List<Map<String, Object>> statusList = sell.selectByStatus(storeUrl);
		List<Map<String, Object>> reviewList = sell.selectByStoreUrl(storeUrl);
		List<OrderSumDTO> orderSumList = sell.selectByDayOrderSum(storeUrl);
		
		int reviewCount = reviewList.size();
		
		
		model.addAttribute("reviewCount", reviewCount);
		model.addAttribute("storeUrl", storeUrl);
		model.addAttribute("statusList", statusList);
		model.addAttribute("reviewList", reviewList);
		model.addAttribute("orderSumList", orderSumList);
		
		 
		return "store/seller/sellerMyPage";
	 }
	
	// 판매자 상품 등록 페이지
	@GetMapping("/productinsert")
	public String showProductInsertForm(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		model.addAttribute("typeCategories", TypeCategoryEnum.values());
	    model.addAttribute("uCategories", UCategoryEnum.values());

	    // ✅ dCategory를 uCategory 기준으로 그룹핑해서 Map에 담기
	    Map<Integer, List<Map<String, Object>>> dCategoriesByU = Arrays.stream(DCategoryEnum.values())
	    	    .collect(Collectors.groupingBy(
	    	        d -> d.getUcategory().getId(),  // key: uCategoryId
	    	        Collectors.mapping(d -> {
	    	            Map<String, Object> map = new HashMap<>();
	    	            map.put("id", d.getId());
	    	            map.put("name", d.getName());
	    	            return map;
	    	        }, Collectors.toList())
	    	    ));

	    model.addAttribute("dCategoriesByU", dCategoriesByU); // ✅ Map<Integer, List<id-name>> 형태

	    return "store/seller/productInsert";
	}

	// 판매자 페이지 상품 리스트 조회
	@GetMapping("/products")
	public String showProductListPage(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		List<ProductlistDTO> productList = productService.productAllListByStoreUrl(storeUrl);
	    model.addAttribute("productList", productList);
	    return "store/seller/productSelect";
	}
	
	// 판매 상품 상세 보기
	@GetMapping("/productdetail/{productId}")
    public String showProductDetailPage(@PathVariable String storeUrl,
                                        @PathVariable int productId,
                                        Model model) {
		setStoreNavInfo(storeUrl, model);
        return "store/productDetail";
	}

	// 판매 상품 수정 페이지 조회
	@GetMapping("/productupdate/{productid}")
	public String showProductUpdateForm(@PathVariable String storeUrl,
	                                    @PathVariable int productid,
	                                    Model model,
	                                    HttpServletResponse response) throws IOException {
		setStoreNavInfo(storeUrl, model);
	    ProductUpdateDTO product = productService.getProductDetail(storeUrl, productid);
	    if (product == null) {
	        response.setContentType("text/html;charset=UTF-8");
	        PrintWriter out = response.getWriter();
	        out.println("<script>alert('해당 상품을 수정할 권한이 없습니다.'); location.href='/create/" + storeUrl + "/seller/products';</script>");
	        out.flush();
	        return null;
	    }

	    ObjectMapper mapper = new ObjectMapper();
	    String productJson = mapper.writeValueAsString(product); // JSON 문자열 생성

	    model.addAttribute("product", product);
	    model.addAttribute("productJson", productJson);
	    model.addAttribute("typeCategories", TypeCategoryEnum.values());
	    model.addAttribute("uCategories", UCategoryEnum.values());

	    // 소분류 그룹핑
	    Map<Integer, List<Map<String, Object>>> dCategoriesByU = Arrays.stream(DCategoryEnum.values())
	        .collect(Collectors.groupingBy(
	            d -> d.getUcategory().getId(),
	            Collectors.mapping(d -> {
	                Map<String, Object> map = new HashMap<>();
	                map.put("id", d.getId());
	                map.put("name", d.getName());
	                return map;
	            }, Collectors.toList())
	        ));
	    model.addAttribute("dCategoriesByU", dCategoriesByU);

	    return "store/seller/productUpdate";
	}
	
	
	// 판매 정산 관리
	@GetMapping("/management/settlement")
    public String showSellrSettlementPage(@PathVariable String storeUrl,
                                        Model model) {
		setStoreNavInfo(storeUrl, model);
        return "store/seller/sellerSettlement";
	}
		
	// 판매자 페이지 주문 조회
	@GetMapping("/management/order")
	public String showOrderPage(@PathVariable String storeUrl,
	                            @RequestParam(value = "status", required = false) String status,
	                            Model model) {
		setStoreNavInfo(storeUrl, model);
		List<OrderDTO> orderList;

	    if (status != null && !status.isBlank()) {
	        try {
	            OrderStatusEnum statusEnum = OrderStatusEnum.from(status);
	            orderList = omService.selectForOrderStatus(storeUrl, statusEnum);
	            model.addAttribute("selectedStatus", statusEnum.getCode());
	        } catch (IllegalArgumentException e) {
	            orderList = omService.selectOrderAll(storeUrl);
	            model.addAttribute("selectedStatus", "");
	        }
	    } else {
	        orderList = omService.selectOrderAll(storeUrl);
	        model.addAttribute("selectedStatus", "");
	    }

	    for (OrderDTO dto : orderList) {
	        dto.setOrderStatusLabel(convertStatusLabel(dto.getOrderStatus()));
	        dto.setAddressFull(dto.getAddressRoad() + " " + dto.getAddressDetail() + " " + dto.getAddressExtra());
	    }
	    model.addAttribute("orderList", orderList);
	    return "store/seller/sellerOrderManage";
	}
	private String convertStatusLabel(OrderStatusEnum status) {
	    switch (status) {
	        case CONFIRM: return "주문완료";
	        case REFUND: return "환불요청";
	        case REFUND_OK: return "환불완료";
	        case ORDER_OK: return "발송전";
	        default: return "기타";
	    }
	}
	
	// 판매 리뷰 관리
	@GetMapping("/reviews")
	public String showReviewPage(@PathVariable String storeUrl, Model model) {
	    setStoreNavInfo(storeUrl, model);

	    List<ReviewManagementDTO> reviewList = reviewService.selectAllMyReview(storeUrl);

	    model.addAttribute("reviewList", reviewList);

	    return "store/seller/sellerReview";
	}
	
	// 문의 메시지
	@GetMapping("/message")
	public String showChatPage(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/seller/chat";
	}
	
	// 스토어 정보 조회
	@GetMapping("/management/seller")
	public String storeManagement(@PathVariable String storeUrl, Model model) {
	    setStoreNavInfo(storeUrl, model);

	    return "store/seller/sellerInfoUpdate";
	}
	
	// 공지사항목록
	@GetMapping("/management/notices")
	public String showNoticePage(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/seller/sellerNotice";
	}
	
	// 폐업 페이지 불러오기
	@GetMapping("/close")
	public String showDonePage(@PathVariable String storeUrl, Model model) {
		setStoreNavInfo(storeUrl, model);
		return "store/seller/storeClose";
	}
	
	// 폐업 처리 로직
	@PostMapping("/close")
	public String handleShutdown(@PathVariable String storeUrl,
	                             @RequestParam("email") String email,
	                             @RequestParam("password") String password,
	                             HttpSession session,
	                             Model model) {
		setStoreNavInfo(storeUrl, model);
	    MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");

	    // 로그인된 사용자와 입력 정보 비교
	    if (loginMember == null || !loginMember.getMemberEmail().equals(email)) {
	        model.addAttribute("errorMessage", "이메일이 일치하지 않습니다.");
	        model.addAttribute("storeUrl", storeUrl);
	        return "store/seller/storeClose";
	    }

	    try {
	        MemberEntity validatedMember = loginService.login(email, password);

	        if (!validatedMember.equals(loginMember)) {
	            model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
	            return "store/seller/storeClose";
	        }

	        int result = shutdownService.shutdown(storeUrl);
	        if (result > 0) {
	            return "redirect:/main"; // 메인 페이지로 이동 (세션 유지)
	        } else {
	            model.addAttribute("errorMessage", "폐업 처리에 실패했습니다.");
	        }
	    } catch (LoginFailException e) {
	        model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
	        return "store/seller/storeClose";
	    } catch (IllegalStateException e) {
	        model.addAttribute("errorMessage", e.getMessage());
	    }

	    return "store/seller/storeClose";
	}
	
}
