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
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.main.SellerMainService;

@RestController
@RequestMapping("/api/{storeUrl}/seller")
public class SellerMainRestController {
 
	@Autowired
	SellerMainService sell;

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
}
