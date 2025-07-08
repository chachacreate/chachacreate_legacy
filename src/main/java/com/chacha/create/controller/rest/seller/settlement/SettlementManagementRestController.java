package com.chacha.create.controller.rest.seller.settlement;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.settlement.SettlementManagementService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/api/{storeUrl}/seller")
public class SettlementManagementRestController {

	@Autowired
	private SettlementManagementService ssmService;

	@GetMapping(value = "/management/settlement", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<Map<String, Object>>> sellerSettlementManagement(@PathVariable String storeUrl) {
		Map<String, Object> result = new java.util.LinkedHashMap<>();
	    result.put("settlementByDayList", ssmService.sellerDaySellManagement(storeUrl));
	    result.put("settlementList", ssmService.sellerSettlementManagement(storeUrl));
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "정산 관리 데이터 조회 성공", result));
	}
}
