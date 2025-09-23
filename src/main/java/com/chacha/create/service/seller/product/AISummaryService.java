package com.chacha.create.service.seller.product;

import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.product.AISummaryDTO;
import com.chacha.create.common.mapper.product.ProductMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AISummaryService {

	private final ProductMapper productMapper;
	
	public AISummaryDTO aiSummaryByCategoryName(String categoryName) {
		return productMapper.findForCategoryPriceSummaryByCategoryName(categoryName);
	}
}
