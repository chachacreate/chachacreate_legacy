package com.chacha.create.common.enums.category;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 하위 카테고리 열거형(enum) 클래스.
 * <p>
 * d_category 테이블과 매핑되며, 상위 카테고리({@link UCategoryEnum})에 속한 세부 카테고리 정보를 정의합니다.
 * 각각의 항목은 u_category_id(외래키)를 통해 {@link UCategoryEnum}과 연결됩니다.
 * </p>
 * 
 * <pre>
 * 예시 JSON 응답:
 * {
 *   "id": 3,
 *   "name": "가방",
 *   "uCategory": {
 *     "id": 2,
 *     "name": "패션잡화"
 *   }
 * }
 * </pre>
 */
@Getter
@AllArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.STRING)
public enum DCategoryEnum {

    // 패션잡화
    TOP(1, "상의", UCategoryEnum.FASHION),
    BOTTOM(2, "하의", UCategoryEnum.FASHION),
    BAG(3, "가방", UCategoryEnum.FASHION),
    WALLET(4, "지갑", UCategoryEnum.FASHION),
    FASHION_ETC(5, "기타(목도리, 모자, 벨트 등)", UCategoryEnum.FASHION),

    // 인테리어 소품
    DIFFUSER(6, "디퓨저, 캔들", UCategoryEnum.INTERIOR),
    MOOD_LIGHT(7, "무드등", UCategoryEnum.INTERIOR),
    FLOWER_PLANT(8, "꽃, 식물", UCategoryEnum.INTERIOR),
    FURNITURE(9, "가구", UCategoryEnum.INTERIOR),

    // 악세서리
    RING(10, "반지", UCategoryEnum.ACCESSORY),
    BRACELET(11, "팔찌", UCategoryEnum.ACCESSORY),
    NECKLACE(12, "목걸이", UCategoryEnum.ACCESSORY),
    KEYRING(13, "키링", UCategoryEnum.ACCESSORY),

    // 생활잡화
    SOAP(14, "비누", UCategoryEnum.LIFESTYLE),
    DISH(15, "그릇", UCategoryEnum.LIFESTYLE),
    TABLEWARE(16, "식기류", UCategoryEnum.LIFESTYLE),
    CUP(17, "컵", UCategoryEnum.LIFESTYLE),
    CASE(18, "케이스", UCategoryEnum.LIFESTYLE),

    // 기타
    PERFUME(19, "향수", UCategoryEnum.ETC),
    DOLL(20, "인형", UCategoryEnum.ETC),
    PET(21, "반려동물", UCategoryEnum.ETC),
    STATIONERY(22, "문구", UCategoryEnum.ETC);

    /** 하위 카테고리 고유 ID (d_category 테이블의 기본 키) */
    private final int id;

    /** 하위 카테고리 이름 */
    private final String name;

    /** 연결된 상위 카테고리 (u_category 테이블의 외래키 매핑) */
    private final UCategoryEnum ucategory;

    /**
     * 주어진 상위 카테고리에 해당하는 하위 카테고리 목록을 반환합니다.
     *
     * @param uCategory 상위 카테고리 enum
     * @return 해당 상위 카테고리에 속하는 {@link DCategoryEnum} 리스트
     */
    
    public UCategoryEnum getUcategory() { return ucategory; }
    
    public static List<DCategoryEnum> getByUCategory(UCategoryEnum uCategory) {
        return Arrays.stream(values())
                .filter(d -> d.ucategory == uCategory)
                .collect(Collectors.toList());
    }

    /**
     * 주어진 ID에 해당하는 하위 카테고리 enum을 반환합니다.
     *
     * @param id 하위 카테고리 ID
     * @return ID에 해당하는 {@link DCategoryEnum} 값
     * @throws IllegalArgumentException 해당 ID에 대응하는 enum이 없는 경우 예외 발생
     */
    @JsonCreator
    public static DCategoryEnum fromJson(Object input) {
        if (input instanceof Integer) {
            return fromId((Integer) input);
        }
        if (input instanceof String) {
            String str = (String) input;
            // 숫자 문자열이면 숫자로 변환 시도
            try {
                int id = Integer.parseInt(str);
                return fromId(id);
            } catch (NumberFormatException e) {
                // 이름 비교
                for (DCategoryEnum d : values()) {
                    if (d.name().equalsIgnoreCase(str) || d.name.equals(str)) {
                        return d;
                    }
                }
            }
        }
        throw new IllegalArgumentException("Invalid DCategory input: " + input);
    }

    public static DCategoryEnum fromId(int id) {
        for (DCategoryEnum d : values()) {
            if (d.id == id) return d;
        }
        throw new IllegalArgumentException("Invalid DCategory id: " + id);
    }
    
    @Override
    public String toString() {
        return name;
    }

}
