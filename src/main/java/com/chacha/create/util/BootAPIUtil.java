package com.chacha.create.util;

import com.chacha.create.common.dto.boot.BootAddressDTO;
import com.chacha.create.common.dto.boot.BootMemberDTO;
import com.chacha.create.common.dto.error.ApiResponse;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Slf4j
@Component
public class BootAPIUtil {

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${spring.boot.api.url}")
    private String bootApiUrl;

    /**
     * 부트 서버에서 판매자 정보 조회
     */
    public BootMemberDTO getBootSellerDataBySellerId(Integer sellerId) {
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
        String url = bootApiUrl + "/info/memberAdress/" + memberId;

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
        String url = bootApiUrl + "/info/memberAdressByAddresId/" + addressId;

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
}