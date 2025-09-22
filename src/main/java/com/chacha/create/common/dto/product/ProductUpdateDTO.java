package com.chacha.create.common.dto.product;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductUpdateDTO {
    private int productId;
    private String productName;
    private String productDetail;
    private int price;
    private int stock;

    private int typeCategoryId;
    private String typeCategoryName;
	private int dcategoryId;
	private String dcategoryName;
	private int ucategoryId;
	private String ucategoryName;
	
	List<ProductImageDTO> images;
}
