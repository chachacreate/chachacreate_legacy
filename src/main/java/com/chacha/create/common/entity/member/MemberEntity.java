package com.chacha.create.common.entity.member;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 회원 정보를 나타내는 엔티티 클래스입니다.
 * <p>
 * DB의 {@code member} 테이블과 매핑되며,
 * 회원의 기본 정보를 저장합니다.
 * </p>
 *
 * <pre>
 * 예시:
 * memberId: 1
 * memberEmail: user@example.com
 * memberName: 홍길동
 * memberPwd: (암호화된 비밀번호)
 * memberPhone: 010-1234-5678
 * memberRegi: 주민등록번호 (또는 기타 식별번호)
 * joinDate: 2023-01-01
 * </pre>
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MemberEntity {

    /**
     * 회원 고유 ID (기본 키)
     */
    private Integer memberId;

    /**
     * 회원 이메일 (로그인 ID 역할)
     */
    private String memberEmail;

    /**
     * 회원 이름
     */
    private String memberName;

    /**
     * 회원 비밀번호 (암호화된 상태로 저장)
     */
    private String memberPwd;

    /**
     * 회원 전화번호
     */
    private String memberPhone;

    /**
     * 회원 주민등록번호
     */
    private String memberRegi;

    /**
     * 회원 가입일자
     */
    private Date joinDate;
    
    /**
     * 회원 가입일자
     */
    private String memberRole;
}
