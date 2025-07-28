package com.chacha.create.common.dto.product;



import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HomeDTO {
	
	 // 메인홈 메인페이지에서 사용할 필드 추가
	private Integer storeId;
    private String storeName;
    private String storeUrl;
    private String logoImg;
    private String storeDetail;
    private String categoryName;
    private Integer saleCnt;
    private Integer Rnk;
    
}
