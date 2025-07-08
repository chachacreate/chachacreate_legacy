package com.chacha.create.common.entity.category;

import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 하위 카테고리 엔티티 클래스
 * <p>
 * DB의 {@code d_category} 테이블과 매핑되는 클래스입니다.
 * 각 수공예 상품이 속한 세부 카테고리를 나타내며,
 * 상위 카테고리({@link UCategoryEnum})와 외래키로 연결됩니다.
 * </p>
 *
 * <pre>
 * 예시 데이터:
 * dCategory: DCategoryEnum.BAG
 * uCategory: UCategoryEnum.FASHION (패션잡화)
 * </pre>
 */
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class DCategoryEntity {

    /** 하위 카테고리 enum (기본 키 역할) */
    private DCategoryEnum dcategoryId;

    /** 상위 카테고리 enum (외래키 역할) */
    private UCategoryEnum ucategoryId;

    /** 하위 카테고리 이름 (예: 가방, 반지 등) */
    private String dcategoryName;

}
