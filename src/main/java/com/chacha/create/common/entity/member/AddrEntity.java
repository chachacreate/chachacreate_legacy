package com.chacha.create.common.entity.member;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 회원의 배송지 정보를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code address} 테이블과 매핑되며, 한 명의 회원은 여러 주소를 가질 수 있습니다.
 * 기본 배송지 여부를 나타내는 필드도 포함되어 있습니다.
 * </p>
 *
 * <pre>
 * 예시:
 * - addressId: 10
 * - memberId: 5
 * - postNum: "06234"
 * - addressRoad: "서울특별시 강남구 테헤란로 123"
 * - addressDetail: "101동 1201호"
 * - addressExtra: "역삼푸르지오시티"
 * - addressCheck: 1 (기본 배송지)
 * </pre>
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AddrEntity {

    /**
     * 주소 고유 ID (기본 키)
     */
    private Integer addressId;

    /**
     * 주소를 소유한 회원의 ID (외래키)
     */
    private Integer memberId;

    /**
     * 우편번호 (예: 06234)
     */
    private String postNum;

    /**
     * 도로명 주소
     */
    private String addressRoad;

    /**
     * 상세 주소 (건물/호수 등)
     */
    private String addressDetail;

    /**
     * 참고 항목 (예: 아파트 이름 등)
     */
    private String addressExtra;

    /**
     * 기본 배송지 여부 (1: 기본, 0: 일반)
     */
    private Integer addressCheck;
}
