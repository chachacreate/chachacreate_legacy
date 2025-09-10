package com.chacha.create.controller.rest.mainhome.store;

import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.mainhome.store.StoreService;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/main/store")
public class StoreRestController {
    
    @Autowired
    private StoreService storeService;
    
    @GetMapping("/stores")
    public ResponseEntity<ApiResponse<List<StoreEntity>>> storeList() {
        List<StoreEntity> stores = storeService.selectAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, stores));
    }
    
    @PostMapping(value = "/openform", consumes = "multipart/form-data", produces = "application/json")
    public ResponseEntity<ApiResponse<String>> storeCreate(
            @RequestParam("storeName") String storeName,
            @RequestParam("storeUrl") String storeUrl,
            @RequestParam("storeDetail") String storeDetail,
            @RequestParam("logoImg") MultipartFile logoImg,
            HttpServletResponse response,
            HttpSession session) {
        
        MemberEntity memberEntity = (MemberEntity) session.getAttribute("loginMember");
        log.info("로그인 사용자: {}", memberEntity);
        
        // StoreEntity 생성
        StoreEntity storeEntity = new StoreEntity();
        storeEntity.setStoreName(storeName);
        storeEntity.setStoreUrl(storeUrl);
        storeEntity.setStoreDetail(storeDetail);
        
        log.info("입력받은 스토어 정보: {}", storeEntity);
        
        String accessToken = storeService.storeUpdate(storeEntity, memberEntity, logoImg, true, response);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, accessToken));
    }
    
    @GetMapping("/checkurl")
    public ResponseEntity<Boolean> checkStoreUrlDuplicate(@RequestParam String storeUrl) {
        boolean exists = storeService.existsByStoreUrl(storeUrl);
        return ResponseEntity.ok(!exists);  // true: 사용 가능, false: 중복
    }
}