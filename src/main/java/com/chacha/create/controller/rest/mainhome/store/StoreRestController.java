package com.chacha.create.controller.rest.mainhome.store;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.mainhome.store.StoreService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/api/main/store")
public class StoreRestController {

    @Autowired
    private StoreService storeService;

    @GetMapping("/stores")
    public ResponseEntity<ApiResponse<List<StoreEntity>>> storeList() {
        List<StoreEntity> stores = storeService.selectAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, stores));
    }

    @PutMapping("/openform")
    public ResponseEntity<ApiResponse<Integer>> storeCreate(HttpSession session, @RequestBody StoreEntity storeEntity) {
        MemberEntity memberEntity = (MemberEntity) session.getAttribute("loginMember");
        log.info("로그인 사용자 : {} 입력받은 스토어 정보 : {}", memberEntity, storeEntity);
        
        int result = storeService.storeUpdate(storeEntity, memberEntity, true);
        return ResponseEntity.status(ResponseCode.OK.getStatus())
                             .body(new ApiResponse<>(ResponseCode.OK, result));
    }
    
    @GetMapping("/checkurl")
    public ResponseEntity<Boolean> checkStoreUrlDuplicate(@RequestParam String storeUrl) {
        boolean exists = storeService.existsByStoreUrl(storeUrl);
        return ResponseEntity.ok(!exists);  // true: 사용 가능, false: 중복
    }
}