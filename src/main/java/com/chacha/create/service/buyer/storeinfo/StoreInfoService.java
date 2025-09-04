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
            Integer sellerId = sellerMapper
                    .selectMemberIdForSellerId(storeMapper.selectByStoreUrl(storeUrl).getSellerId());

            BootMemberDTO memberData = bootAPIUtil.getBootMemberDataBySellerId(sellerId);

            List<SellerInfoDTO> result = new ArrayList<>();
            if (memberData != null) {
                SellerInfoDTO temp = SellerInfoDTO.builder()
                        .sellerName(memberData.getName())
                        .sellerEmail(memberData.getEmail())
                        .sellerPhone(memberData.getPhone())
                        .build();
                log.info(temp.toString());
                result.add(temp);
            }
            return result;

        } catch (Exception e) {
            log.error("API 호출 실패: ", e);
            return null;
        }
    }

    public StoreInfoDTO selectForThisStoreInfo(String storeUrl) {
        return storeMapper.selectForThisStoreInfo(storeUrl);
    }
}
