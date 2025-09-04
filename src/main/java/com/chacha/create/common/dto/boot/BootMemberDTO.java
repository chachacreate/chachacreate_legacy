package com.chacha.create.common.dto.boot;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true) // 추가 필드 무시
public class BootMemberDTO {
	private Long id;
    private String name;
    private String email;
    private String phone;
    private String memberRole;
    private Boolean isDeleted;
    private String password;
    private String registrationNumber;
    // 다른 필드들도 필요시 추가
}