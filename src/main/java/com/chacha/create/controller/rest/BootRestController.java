package com.chacha.create.controller.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.boot.BootOrderStatusRequestDTO;
import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.ProductDetailDTO;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.product.ProductEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.mapper.order.OrderDetailMapper;
import com.chacha.create.common.mapper.product.ProductManageMapper;
import com.chacha.create.common.mapper.product.ProductMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/legacy")
@Slf4j
public class BootRestController {
	
	@Autowired
	StoreMapper storemapper;
	
	@Autowired
	ProductManageMapper productManageMapper;
	
	@Autowired
	OrderDetailMapper orderDetailMapper;
	
	@GetMapping("/info/store/{storeUrl}")
	public ApiResponse<StoreEntity> getStoreDetailByName(@PathVariable String storeUrl) {
		log.info("boot에서 스토어 조회");
		return new ApiResponse<>(ResponseCode.OK,storemapper.selectByStoreUrl(storeUrl));
	}
	
	@GetMapping("/info/seller/{storeUrl}")
	public ApiResponse<SellerEntity> getSellerDetailByName(@PathVariable String storeUrl) {
		log.info("boot에서 seller 조회");
		return new ApiResponse<>(ResponseCode.OK,storemapper.selectForSellerDetail(storeUrl));
	}
	
	@GetMapping(value = "/info/store/id/{storeId}", produces = "application/json")
    public ApiResponse<StoreEntity> getStoreDetailById(@PathVariable Long storeId) {
        log.info("boot에서 스토어 조회 - by id: {}", storeId);
        // StoreMapper 시그니처가 int라면 변환 필요
        int id = Math.toIntExact(storeId);
        return new ApiResponse<>(ResponseCode.OK, storemapper.selectByStoreId(id));
    }
	
	@GetMapping("/info/product/{productId}")
	public ApiResponse<ProductDetailDTO> getProductDetailById(@PathVariable int productId) {
		log.info("boot에서 상품 조회");
		return new ApiResponse<>(ResponseCode.OK, productManageMapper.selectProductWithThumbnail(productId));
	}
	
	@PostMapping("/order/status/update")
	public ApiResponse<Void> updateOrderStatus(@RequestBody BootOrderStatusRequestDTO request) {
		log.info("boot에서 주문 상태 업데이트 요청");
		orderDetailMapper.updateStatus(request.getOrderDetailId(), request.getOrderStatus());
		return new ApiResponse<>(ResponseCode.OK, "주문 상태 업데이트 성공!");
	}
	
}
