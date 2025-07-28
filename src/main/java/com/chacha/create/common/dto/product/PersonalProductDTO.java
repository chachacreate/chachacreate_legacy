package com.chacha.create.common.dto.product;

import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;
import com.fasterxml.jackson.annotation.JsonIgnore;
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
public class PersonalProductDTO {
    private String productName;
    private String productDetail;
    private int price;
    private int stock;
    private String pimgUrl1;
    private String pimgUrl2;
    private String pimgUrl3;
    
    @JsonIgnore
    private int sellerId;
    @JsonIgnore
    private int storeId;

    private int productId;
    
    private TypeCategoryEnum typeCategoryId;
	private DCategoryEnum dcategoryId;
	private UCategoryEnum ucategoryId;
	private String typeCategoryName;
	private String dcategoryName;
	private String ucategoryName;
}