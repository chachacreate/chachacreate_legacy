package com.chacha.create.common.dto.manager;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StoreManagerUpdateDTO {

	    // 스토어 테이블 필드
	    private String storeId;
	    private String storeName;
	    private String storeDetail;
	    private String logoImg;

	    // 판매자 테이블 필드
	    private String sellerId;
	    private String account;
	    private String accountBank;
	    private String profileInfo;
	    
	    // 회원 테이블 필드
	    private String memberId;
	    private String memberPwd;
	    private String memberPhone;

}
