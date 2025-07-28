package com.chacha.create.common.dto.manager;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ManagerAdjustmentDTO {
	
	private String storeName;           // 스토어명
    private String sellerName;          // 판매자 이름
    private String accountNumber;       // 계좌번호
    private String accountBank;            // 은행명
    private String accountHolder;       // 예금주
    private Integer adjustmentAmount;   // 정산금액
    private String adjustmentStatus;    // 정산 상태 (고정값 '정산 예정')
    private String adjustmentDate;

}
