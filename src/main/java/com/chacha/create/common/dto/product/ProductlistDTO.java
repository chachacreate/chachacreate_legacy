package com.chacha.create.common.dto.product;

import java.sql.Date;

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
public class ProductlistDTO {
	private String pimgUrl;
	private Integer productId;
	private String productName;
	private Integer price;
	private Integer stock;
	private Integer typeCategoryId;
	private String typeCategoryName;
	private UCategoryEnum ucategoryId;
	private String ucategoryName;
	private Integer dcategoryId;
	private String dcategoryName;
	private Date productDate;
	private Date lastModifiedDate;
	private Integer flagshipCheck;
	private Integer deleteCheck;
	private String  middleCategoryName;
}

