package com.chacha.create.common.dto.product;

import java.util.List;
import lombok.Getter;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * 특정 상품의 대표이미지 + 일별 결제금액 응답
 */
@Getter@Builder @AllArgsConstructor @NoArgsConstructor @ToString
public class ProductDailySettlementDTO {
	private Integer productId;			// 상품 ID
	private List<DailyEntry> daily;	// 일자/금액 목록
	
	@Getter@Builder @AllArgsConstructor @NoArgsConstructor @ToString
    public static class DailyEntry {
        private String date;   // YYYY-MM-DD
        private Integer amount; // 해당일 결제 합계
    }

}
