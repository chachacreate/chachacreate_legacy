package com.chacha.create.common.entity.category;

import com.chacha.create.common.enums.category.UCategoryEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상위 카테고리 엔티티 클래스
 * <p>
 * DB의 {@code u_category} 테이블과 매핑되며,
 * 수공예 상품의 대분류(상위 카테고리)를 나타냅니다.
 * </p>
 *
 * <pre>
 * 예시 데이터:
 * uCategory: UCategoryEnum.CRAFT (공예)
 * </pre>
 */
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class UCategoryEntity {

    /** 상위 카테고리 enum (기본 키 역할) */
    private UCategoryEnum ucategoryId;

    /** 상위 카테고리 이름 (예: 공예, 패션잡화 등) */
    private String ucategoryName;
}
