package com.chacha.create.common.dto.login;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NaverClientDTO {
    private String clientId;
    private String redirectUri;
    private String clientSecret;
}
