package com.chacha.create.common.entity.member;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 판매자 정보를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code seller} 테이블과 매핑되며,
 * 회원 중 판매자에 해당하는 사용자의 상세 정보를 저장합니다.
 * </p>
 *
 * <pre>
 * 예시:
 * sellerId: 101
 * memberId: 5
 * openingDate: 2023-01-01
 * account: 123-456-7890
 * accountBank: 국민은행
 * profileInfo: 판매자 프로필 정보 및 소개
 * personalCheck: 개인판매자 여부(0: 판매자, 1:개인판매자)
 * </pre>
 */
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class SellerEntity {

    /**
     * 판매자 고유 ID (기본 키)
     */
    private Integer sellerId;

    /**
     * 회원 ID (외래키, 회원 테이블과 연관)
     */
    private Integer memberId;

    /**
     * 판매자 등록 또는 개설 날짜
     */
    private Date openingDate;

    /**
     * 판매자 계좌 번호
     */
    private String account;

    /**
     * 판매자 계좌 은행명
     */
    private String accountBank;

    /**
     * 판매자 프로필 정보 및 소개
     */
    private String profileInfo;
    
    /**
     * 개인판매자 여부
     */
    private Integer personalCheck;
}
