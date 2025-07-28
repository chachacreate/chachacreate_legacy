package com.chacha.create.common.dto.member;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SellerInfoDTO {

	private String sellerName;
	private String sellerPhone;
	private String sellerEmail;
	private String sellerProfile;
}
