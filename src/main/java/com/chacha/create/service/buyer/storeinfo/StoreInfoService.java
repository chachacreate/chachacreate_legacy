package com.chacha.create.service.buyer.storeinfo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.boot.BootMemberDTO;
import com.chacha.create.common.dto.member.SellerInfoDTO;
import com.chacha.create.common.dto.store.StoreInfoDTO;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
@RequiredArgsConstructor
public class StoreInfoService {

    private final StoreMapper storeMapper;
    private final SellerMapper sellerMapper;
    private final BootAPIUtil bootAPIUtil; // 새로 주입받음

    public List<StoreEntity> selectByStoreInfo(String storeUrl) {
        return storeMapper.selectByStoreInfo(storeUrl);
    }

    public List<SellerInfoDTO> selectBySellerInfo(String storeUrl){
        try {
            // 1) storeUrl -> sellerId
            Integer sellerId = storeMapper.selectByStoreUrl(storeUrl).getSellerId();
            log.info("sellerId: {}", sellerId);

            // 2) sellerId -> memberId
            Integer memberId = sellerMapper.selectMemberIdForSellerId(sellerId);
            log.info("memberId: {}", memberId);

            BootMemberDTO memberData = bootAPIUtil.getBootMemberDataByMemberId(memberId);

            String legacyProfile = sellerMapper.selectProfileInfoBySellerId(sellerId);

            if (memberData == null) {
                log.warn("No Boot memberData. sellerId={}, memberId={}", sellerId, memberId);
                return List.of();
            }

            SellerInfoDTO dto = SellerInfoDTO.builder()
                    .sellerName(memberData.getName())
                    .sellerEmail(memberData.getEmail())
                    .sellerPhone(memberData.getPhone())
                    .sellerProfile(legacyProfile)
                    .build();
            log.info("SellerInfoDTO={}", dto);
            return List.of(dto);

        } catch (Exception e) {
            log.error("API 호출 실패: ", e);
            return List.of(); 
        }
    }


    public StoreInfoDTO selectForThisStoreInfo(String storeUrl) {
        return storeMapper.selectForThisStoreInfo(storeUrl);
    }
}
