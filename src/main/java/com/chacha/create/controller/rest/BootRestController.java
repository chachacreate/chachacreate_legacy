package com.chacha.create.controller.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/legacy")
@Slf4j
public class BootRestController {
	
	@Autowired
	StoreMapper storemapper;
	
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
}
