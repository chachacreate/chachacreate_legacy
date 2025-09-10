package com.chacha.create.common.dto.product;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

/**
 * 상품 일별 매출 응답 DTO
 * - ymd: 매출 발생 날짜
 * - amt: 해당 날짜의 총 매출 금액
 */
@AllArgsConstructor
@Builder
@Getter
@ToString
public class ProductSalesResponseDTO {
    private String ymd;   // 매출 날짜 (YYYY-MM-DD)
    private Integer amt;  // 매출 금액
}

