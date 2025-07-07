package com.chacha.create.common.dto.store;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StoreInfoDTO {
    /** 상점 로고 이미지 경로 또는 URL */
    private String logoImg;
    /** 상점 이름 */
    private String storeName;
    /** 회원 ID */
    private Integer memberId;
}
