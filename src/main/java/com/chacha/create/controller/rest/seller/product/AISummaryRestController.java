package com.chacha.create.controller.rest.seller.product;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.AIRequestDTO;
import com.chacha.create.common.dto.product.AISummaryDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.product.AISummaryService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/legacy")
public class AISummaryRestController {
	private final AISummaryService aiService;
	
	
	@PostMapping(value = "/summary", produces = MediaType.APPLICATION_JSON_VALUE)
	public ApiResponse<AISummaryDTO> categorySummary(@RequestBody AIRequestDTO aiRequestDTO){
		log.debug(aiRequestDTO.getCategoryName());
		return new ApiResponse<AISummaryDTO>(ResponseCode.OK, aiService.aiSummaryByCategoryName(aiRequestDTO.getCategoryName()));
	}
	
}
