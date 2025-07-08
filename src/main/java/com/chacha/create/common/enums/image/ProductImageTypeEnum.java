package com.chacha.create.common.enums.image;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 상품 이미지 타입 열거형 (p_img 테이블의 p_img_enum 컬럼과 매핑)
 * <p>
 * - THUMBNAIL: 상품 썸네일 이미지 (대표 이미지)<br>
 * - DESCRIPTION: 상품 상세 설명용 이미지
 * </p>
 *
 * <p><b>입력 예시:</b>
 * <pre>{@code
 * "THUMBNAIL"
 * "썸네일"
 * {"code": "THUMBNAIL", "name": "썸네일"}
 * }</pre>
 * </p>
 *
 * <p><b>출력 예시:</b>
 * <pre>{@code
 * "썸네일"
 * }</pre>
 * </p>
 */
@Getter
@AllArgsConstructor
public enum ProductImageTypeEnum {
    THUMBNAIL("THUMBNAIL", "썸네일"),
    DESCRIPTION("DESCRIPTION", "상세설명");

    private final String code;
    @JsonValue
    private final String name;

    @JsonCreator
    public static ProductImageTypeEnum from(Object value) {
    	
        if (value instanceof String) {
            String str = (String) value;
            for (ProductImageTypeEnum type : values()) {
                if (type.code.equalsIgnoreCase(str) || type.name.equalsIgnoreCase(str)) {
                    return type;
                }
            }
        } else if (value instanceof Map) {
            Object codeObj = ((Map<?, ?>) value).get("code");
            if (codeObj instanceof String) {
                String codeStr = (String) codeObj;
                for (ProductImageTypeEnum type : values()) {
                    if (type.code.equalsIgnoreCase(codeStr)) {
                        return type;
                    }
                }
            }
        }
        throw new IllegalArgumentException("Invalid ProductImageType: " + value);
    }

    public static ProductImageTypeEnum fromCode(String code) {
        for (ProductImageTypeEnum type : values()) {
            if (type.code.equalsIgnoreCase(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Invalid ProductImageType code: " + code);
    }

    /**
     * DB에 저장할 code 값을 반환합니다.
     */
    public String getCode() {
        return code;
    }
}
