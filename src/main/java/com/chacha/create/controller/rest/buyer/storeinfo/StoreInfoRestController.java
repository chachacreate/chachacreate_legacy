package com.chacha.create.controller.rest.buyer.storeinfo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.member.SellerInfoDTO;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.storeinfo.StoreInfoService;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/legacy/{storeUrl}")
@RequiredArgsConstructor
public class StoreInfoRestController {

    private final StoreInfoService storeinfo;
    private final S3Uploader s3Uploader;

    @GetMapping("/info")
    public ResponseEntity<ApiResponse<Map<String, List<?>>>> storeinfo(@PathVariable String storeUrl) {
        Map<String, List<?>> result = new HashMap<>();

        List<StoreEntity> storeInfoList = storeinfo.selectByStoreInfo(storeUrl);
        List<SellerInfoDTO> sellerInfoList = storeinfo.selectBySellerInfo(storeUrl);
        storeInfoList.forEach(si->si.setLogoImg(s3Uploader.getThumbnailUrlByFullUrl(si.getLogoImg())));
        result.put("storeInfoList", storeInfoList);
        result.put("sellerInfoList", sellerInfoList);

        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }
}
