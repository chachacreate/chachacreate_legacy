package com.chacha.create.common.dto.boot;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * Boot API 응답용 회원 주소 DTO
 */
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
public class BootAddressDTO {
	private Long id;              // 주소 PK
    private Integer memberId;     // 회원 ID (MemberEntity 대신 단순 ID)

    private String postNum;       // 우편번호
    private String addressRoad;   // 도로명 주소
    private String addressDetail; // 상세 주소
    private String addressExtra;  // 참고 항목

    private Boolean isDefault;    // 기본 배송지 여부

    // BaseEntity 필드들
    private String createdAt;
    private String updatedAt;
    private String deletedAt;
    private Boolean isDeleted;
}
