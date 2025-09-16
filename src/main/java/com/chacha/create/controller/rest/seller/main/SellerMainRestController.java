package com.chacha.create.controller.rest.seller.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.order.OrderSumDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.detail.ReviewService;
import com.chacha.create.service.buyer.storeinfo.StoreInfoService;
import com.chacha.create.service.seller.main.SellerMainService;
import com.chacha.create.service.seller.order.OrderManagementService;
import com.chacha.create.service.seller.product.ProductService;
import com.chacha.create.service.seller.shut_down.ShutDownService;
import com.chacha.create.service.store_common.header.auth.LoginService;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/{storeUrl}/seller")
@RequiredArgsConstructor
public class SellerMainRestController {
 
	private final SellerMainService sell;
	private final StoreInfoService storeinfo;
	private final S3Uploader s3Uploader;

	@GetMapping(value = "main", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<Map<String, List<?>>>> sellermain(@PathVariable String storeUrl) {

		Map<String, List<?>> result = new HashMap<>();

		List<Map<String, Object>> statusList = sell.selectByStatus(storeUrl);
		List<Map<String, Object>> reviewList = sell.selectByStoreUrl(storeUrl);
		List<OrderSumDTO> orderSumList = sell.selectByDayOrderSum(storeUrl);

		result.put("statusList", statusList);
		result.put("reviewList", reviewList);
		result.put("orderSumList", orderSumList);

		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "판매자 메인 데이터 조회 성공", result));
	}
	
	@GetMapping
	public ApiResponse<Map<String, Object>> storeNavInfo(@PathVariable String storeUrl){
		Map<String, Object> storeInfo = new HashMap<String, Object>();
		StoreInfoDTO dbStoreInfo = storeinfo.selectForThisStoreInfo(storeUrl);
		storeInfo.put("storeUrl",storeUrl);
		storeInfo.put("logoImg", s3Uploader.getThumbnailUrlByFullUrl(dbStoreInfo.getLogoImg()));
		storeInfo.put("storeOwnerId", dbStoreInfo.getMemberId());
		storeInfo.put("storeName", dbStoreInfo.getStoreName());
		log.info(storeInfo.toString());
		return new ApiResponse<Map<String, Object>>(ResponseCode.OK, "판매자 기본 정보 조회 완료", storeInfo);
	}
}
