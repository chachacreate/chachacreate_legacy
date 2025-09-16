package com.chacha.create.common.dto.product;

import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;
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

    private String pimgUrl1;
    private String pimgUrl2;
    private String pimgUrl3;

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
}
