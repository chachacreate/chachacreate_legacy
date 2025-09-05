package com.chacha.create.common.dto.boot;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BootTokenDTO {
    private BootMemberDTO login;
    private String accessToken;
    private String refreshToken; // 쿠키 방식이면 로그인시에만 임시 사용
}
