package com.chacha.create.controller.rest.seller.settlement;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.ProductDailySettlementDTO;
import com.chacha.create.common.dto.product.ProductSalesResponseDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;
import com.chacha.create.common.dto.product.StoreProductSettlementDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.mapper.product.ProductMapper;
import com.chacha.create.service.seller.settlement.SettlementManagementService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@CrossOrigin(
		  origins = {"http://localhost","http://localhost:5173","http://localhost:3000"},
		  allowCredentials = "true"
		)
@RequestMapping("/legacy/seller/settlements/products")
public class SettlementManagementRestController {

	@Autowired
	private SettlementManagementService ssmService;
	@Autowired
	private ProductMapper productMapper;

	@GetMapping(value = "{storeUrl}/management/settlement", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<Map<String, Object>>> sellerSettlementManagement(@PathVariable String storeUrl) {
		Map<String, Object> result = new java.util.LinkedHashMap<>();
	    result.put("settlementByDayList", ssmService.sellerDaySellManagement(storeUrl));
	    result.put("settlementList", ssmService.sellerSettlementManagement(storeUrl));
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "정산 관리 데이터 조회 성공", result));
	}
	
	/** 스토어 URL로 상품 목록 조회(드롭다운용) */
	@GetMapping(value = "/{storeUrl}/list", produces = MediaType.APPLICATION_JSON_VALUE)
	public ApiResponse<List<ProductlistDTO>> getProductsByStoreUrl(@PathVariable String storeUrl) {
        log.info("[legacy] 상품목록(대표이미지 포함) 조회, storeUrl={}", storeUrl);
        List<ProductlistDTO> list = productMapper.selectListForDropdownByStoreUrl(storeUrl);
        return new ApiResponse<>(ResponseCode.OK, list);
    }
	
	/** 특정 상품의 일별 정산 조회 */
	@GetMapping("/{storeUrl}/{productId}")
	public ApiResponse<ProductDailySettlementDTO> getProductDaily(
	        @PathVariable("productId") Integer productId
	) {
	    log.info("[legacy] 상품 일별 정산 조회, productId={}", productId);

	    ProductDailySettlementDTO dto = ssmService.getProductDailySettlement(productId);

	    if (dto == null || dto.getDaily() == null || dto.getDaily().isEmpty()) {
	        return new ApiResponse<>(ResponseCode.FAIL, null);
	    }
	    return new ApiResponse<>(ResponseCode.OK, dto);
	}
	
	@GetMapping("/{storeUrl}/all")
	public ApiResponse<List<StoreProductSettlementDTO>> getStoreSettlements(
			@PathVariable("storeUrl") String storeUrl
			){
				log.info("legacy 스토어 전체 상품 정산 조회, storeUrl={}", storeUrl);
				List<StoreProductSettlementDTO> list = ssmService.getStoreProductSettlements(storeUrl);
				if(list == null || list.isEmpty()) {
					return new ApiResponse<>(ResponseCode.FAIL,null);
				}
				return new ApiResponse<>(ResponseCode.OK,list);
		
	}
	
	 /**
     * 특정 스토어의 상품 일별 매출 조회
     * @param storeURL
     * @return 매출 리스트 (날짜별 금액)
     */
	@GetMapping("/{storeUrl}/sales")
	 public ApiResponse<List<ProductSalesResponseDTO>> getDailyProductSales(
	            @PathVariable("storeUrl") String storeUrl
	    ) {
	        log.info("[LegacyProductSalesController] 상품 매출 조회 요청");
	        List<ProductSalesResponseDTO> sales = ssmService.getDailyProductSalesByStore(storeUrl);
	        return new ApiResponse<>(ResponseCode.OK, sales);
	    }


}
