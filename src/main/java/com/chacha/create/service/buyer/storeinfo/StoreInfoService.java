package com.chacha.create.service.buyer.storeinfo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.member.SellerInfoDTO;
import com.chacha.create.common.dto.store.BootMemberDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.mapper.manage.ManageMapper;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
@RequiredArgsConstructor
public class StoreInfoService {
	
	private final RestTemplate restTemplate = new RestTemplate();
	
	private final StoreMapper storeMapper;
	private final ManageMapper manageMapper;
	private final SellerMapper sellerMapper;
	
	public List<StoreEntity> selectByStoreInfo(String storeUrl) {

		List<StoreEntity> result =  storeMapper.selectByStoreInfo(storeUrl);
		return result;
	}
	
	public List<SellerInfoDTO> selectBySellerInfo(String storeUrl){
        try {
            String url = "http://localhost:8888/api/info/seller/";
            Integer sellerId = sellerMapper.selectMemberIdForSellerId(storeMapper.selectByStoreUrl(storeUrl).getSellerId());

            ResponseEntity<ApiResponse<BootMemberDTO>> response = 
                restTemplate.exchange(url + sellerId,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<ApiResponse<BootMemberDTO>>() {}
                );

            log.info("Response: {}", response);
            log.info("Response Body: {}", response.getBody());

            List<SellerInfoDTO> result = new ArrayList<SellerInfoDTO>();
            if (response.getBody() != null && response.getBody().getData() != null) {
                BootMemberDTO memberData = response.getBody().getData();

                log.info("Member Data: {}", memberData); // 실제 받은 데이터 확인

                if (memberData != null) {
                	SellerInfoDTO temp = new SellerInfoDTO().builder()
                			.sellerName(memberData.getName())
                			.sellerEmail(memberData.getEmail())
                			.sellerPhone(memberData.getPhone())
                			.build();
                	log.info(temp.toString());
                    result.add(temp);
                }
            }
            return result;

        } catch (Exception e) {
            log.error("API 호출 실패: ", e);
            e.printStackTrace();
        }

        return null;
    }

	public StoreInfoDTO selectForThisStoreInfo(String storeUrl) {
		StoreInfoDTO result =  storeMapper.selectForThisStoreInfo(storeUrl);
		return result;
	}
	
}
