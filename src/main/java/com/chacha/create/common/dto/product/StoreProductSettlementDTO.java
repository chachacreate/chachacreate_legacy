package com.chacha.create.common.dto.product;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * 스토어 전체 상품 정산(레거시 주문/상품 데이터 기반)
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class StoreProductSettlementDTO {
	 
    private String settlementDate;	 /** 정산일자 = 주문일의 다음달 1일 */
    private Long amount;				 /** 정산금액 = 주문상세 (order_cnt * order_price) 합계 */
    private String account;				/** 계좌번호 */
    private String accountBank;					/** 은행명 */
    private String updateAt;		     /** 최근 수정일 = product.last_modified_date 최대값 */
}
