package com.chacha.create.util;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.chacha.create.common.dto.boot.BootAddressDTO;
import com.chacha.create.common.dto.boot.BootMemberDTO;
import com.chacha.create.common.dto.boot.BootTokenDTO;
import com.chacha.create.common.dto.error.ApiResponse;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class BootAPIUtil {

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${spring.boot.api.url}")
    private String bootApiUrl;
    
    /**
     * 부트 서버에 소셜 로그인 (쿠키 포함)
     */
    public BootTokenDTO socialLogin(String memberEmail, HttpServletResponse legacyResponse) {
        String url = bootApiUrl + "/auth/socialLogin";
        try {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> requestEntity = new HttpEntity<>(memberEmail, headers);
        
        ResponseEntity<ApiResponse<BootTokenDTO>> response =
                restTemplate.exchange(url,
                        HttpMethod.POST,
                        requestEntity,
                        new ParameterizedTypeReference<ApiResponse<BootTokenDTO>>() {}
                );

        // Boot 서버에서 받은 쿠키를 Legacy 응답에 복사
        List<String> setCookieHeaders = response.getHeaders().get("Set-Cookie");
        if (setCookieHeaders != null) {
            for (String cookie : setCookieHeaders) {
                legacyResponse.addHeader("Set-Cookie", cookie);
            }
        }

        return response.getBody() != null ? response.getBody().getData() : null;
        }catch (Exception e) {
			log.warn("회원 정보 없음 {}", e);
		}
        return null;
    }

    /**
     * 부트 서버에서 로그인 회원 정보 조회
     */
    public BootMemberDTO getBootMemberDataByMemberId(Integer memberId) {
        String url = bootApiUrl + "/info/member/" + memberId;

        ResponseEntity<ApiResponse<BootMemberDTO>> response =
                restTemplate.exchange(url,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<ApiResponse<BootMemberDTO>>() {}
                );

        log.debug("Boot API Response: {}", response);
        return response.getBody() != null ? response.getBody().getData() : null;
    }
    
    /**
     * 부트 서버에서 로그인 회원 정보 이메일로 조회
     */
    public BootMemberDTO getBootMemberDataByMemberEmail(String memberEmail) {
        String url = bootApiUrl + "/info/memberEmail/" + memberEmail;

        ResponseEntity<ApiResponse<BootMemberDTO>> response =
                restTemplate.exchange(url,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<ApiResponse<BootMemberDTO>>() {}
                );

        log.debug("Boot API Response: {}", response);
        return response.getBody() != null ? response.getBody().getData() : null;
    }
    
    /**
     * 부트 서버에서 판매자 정보 조회
     */
    public BootMemberDTO getBootMemberDataBySellerId(Integer sellerId) {
        String url = bootApiUrl + "/info/seller/" + sellerId;

        ResponseEntity<ApiResponse<BootMemberDTO>> response =
                restTemplate.exchange(url,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<ApiResponse<BootMemberDTO>>() {}
                );

        log.debug("Boot API Response: {}", response);
        return response.getBody() != null ? response.getBody().getData() : null;
    }
    /**
     * 회원 주소 정보 조회 (memberId 기준)
     */
    public BootAddressDTO getBootMemberAddressDataByMemberId(Integer memberId) {
        String url = bootApiUrl + "/info/memberAddress/" + memberId;

        ResponseEntity<ApiResponse<BootAddressDTO>> response =
                restTemplate.exchange(url,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<ApiResponse<BootAddressDTO>>() {}
                );

        BootAddressDTO data = response.getBody() != null ? response.getBody().getData() : null;
        log.debug("getMemberAddress Response: {}", data);
        return data;
    }

    /**
     * 회원 주소 정보 조회 (addressId 기준)
     */
    public BootAddressDTO getBootMemberAddressDataByAddressId(Integer addressId) {
        String url = bootApiUrl + "/info/memberAddressByAddressId/" + addressId;

        ResponseEntity<ApiResponse<BootAddressDTO>> response =
                restTemplate.exchange(url,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<ApiResponse<BootAddressDTO>>() {}
                );

        BootAddressDTO data = response.getBody() != null ? response.getBody().getData() : null;
        log.debug("getMemberAddressByAddressId Response: {}", data);
        return data;
    }
    
    // 회원 주소 정보 등록 (memberId로)
    public BootAddressDTO insertBootMemberAddress(Integer memberId, BootAddressDTO newAddr) {
        String url = bootApiUrl + "/info/memberAddress/" + memberId + "/insert";

        HttpEntity<BootAddressDTO> requestEntity = new HttpEntity<>(newAddr);

        ResponseEntity<ApiResponse<BootAddressDTO>> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                requestEntity,
                new ParameterizedTypeReference<ApiResponse<BootAddressDTO>>() {}
        );

        BootAddressDTO data = response.getBody() != null ? response.getBody().getData() : null;
        log.debug("insertBootMemberAddress Response: {}", data);
        return data;
    }
    
    // 회원 권한 업데이트 + 새 토큰 발급 (쿠키 포함)
    public BootTokenDTO updateMemberRoleWithToken(Long memberId, String memberRole, HttpServletResponse legacyResponse) {
        String url = bootApiUrl + "/auth/role/" + memberId + "/" + memberRole;
        
        try {
            log.info("회원 권한 업데이트 및 토큰 재발급 요청 - memberId: {}, role: {}", memberId, memberRole);
            
            ResponseEntity<ApiResponse<BootTokenDTO>> response =
                    restTemplate.exchange(url,
                            HttpMethod.POST,
                            null,
                            new ParameterizedTypeReference<ApiResponse<BootTokenDTO>>() {}
                    );

            // Boot 서버에서 받은 쿠키를 Legacy 응답에 복사
            List<String> setCookieHeaders = response.getHeaders().get("Set-Cookie");
            if (setCookieHeaders != null) {
                for (String cookie : setCookieHeaders) {
                    legacyResponse.addHeader("Set-Cookie", cookie);
                    log.debug("쿠키 전달: {}", cookie);
                }
            }

            BootTokenDTO data = response.getBody() != null ? response.getBody().getData() : null;
            log.info("회원 권한 업데이트 및 토큰 재발급 완료 - memberId: {}, role: {}", memberId, memberRole);
            return data;
            
        } catch (Exception e) {
            log.error("회원 권한 업데이트 및 토큰 재발급 실패 - memberId: {}, role: {}, 오류: {}", 
                    memberId, memberRole, e.getMessage());
            throw new RuntimeException("회원 권한 업데이트 및 토큰 재발급 중 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * 회원을 판매자로 권한 변경 + 토큰 재발급
     */
    public BootTokenDTO upgradePersonalSellerToSeller(Integer memberId, HttpServletResponse legacyResponse) {
        return updateMemberRoleWithToken(memberId.longValue(), "SELLER", legacyResponse);
    }
    
    /**
     * 회원을 개인 판매자로 권한 변경 + 토큰 재발급
     */
    public BootTokenDTO upgradeMemberToPersonalSeller(Integer memberId, HttpServletResponse legacyResponse) {
        return updateMemberRoleWithToken(memberId.longValue(), "PERSONAL_SELLER", legacyResponse);
    }
    
    /**
     * 회원을 관리자로 권한 변경 + 토큰 재발급
     */
    public BootTokenDTO upgradeMemberToAdmin(Integer memberId, HttpServletResponse legacyResponse) {
        return updateMemberRoleWithToken(memberId.longValue(), "ADMIN", legacyResponse);
    }
    
    /**
     * 회원을 일반 사용자로 권한 변경 + 토큰 재발급
     */
    public BootTokenDTO downgradeMemberToUser(Integer memberId, HttpServletResponse legacyResponse) {
        return updateMemberRoleWithToken(memberId.longValue(), "USER", legacyResponse);
    }

    /**
     * 회원을 개인 판매자로 권한 변경 + 토큰 재발급
     */
    public BootTokenDTO downgradeMemberToPersonalSeller(Integer memberId, HttpServletResponse legacyResponse) {
        return updateMemberRoleWithToken(memberId.longValue(), "USER", legacyResponse);
    }
}