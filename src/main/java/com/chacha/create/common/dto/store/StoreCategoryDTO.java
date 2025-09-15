package com.chacha.create.common.dto.store;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StoreCategoryDTO {
	private String typeCategory;
	private String uCategory;
	private String dCategory;
}
