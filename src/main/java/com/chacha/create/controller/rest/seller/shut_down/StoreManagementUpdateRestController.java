package com.chacha.create.controller.rest.seller.shut_down;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.manager.StoreManagerUpdateDTO;
import com.chacha.create.common.dto.store.StoreInfoManagementDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.manager.store.StoreManagementUpdateService;
import com.chacha.create.service.seller.information.StoreInfoManagementService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}/seller")
@RequiredArgsConstructor
public class StoreManagementUpdateRestController {

    private final StoreManagementUpdateService storeService;
    private final StoreInfoManagementService storeInfoService;
    
    @GetMapping("/management/sellerInfo")
    public ResponseEntity<ApiResponse<StoreInfoManagementDTO>> getmyInfo(@PathVariable String storeUrl, HttpSession session){
        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, storeInfoService.getStoreInfo(storeUrl, loginMember)));
    }
    
    /**
     * 판매자 스토어 정보 수정 (MultipartFile 지원)
     */
    @PostMapping(value = "/management/sellerInfo", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> updateSellerInfo(
            @PathVariable("storeUrl") String storeUrl,
            @RequestParam(value = "storeDetail", required = true) String storeDetail,
            @RequestParam(value = "account", required = true) String account,
            @RequestParam(value = "accountBank", required = true) String accountBank,
            @RequestParam(value = "profileInfo", required = true) String profileInfo,
            @RequestParam(value = "logoImg", required = false) MultipartFile logoImg,
            @RequestParam(value = "existingLogoImg", required = false) String existingLogoImg,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
            if (loginMember == null) {
                response.put("status", 401);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(401).body(response);
            }
            
            log.info("수정 요청 파라미터:");
            log.info("storeUrl: {}", storeUrl);
            log.info("storeDetail: {}", storeDetail);
            log.info("account: {}", account);
            log.info("accountBank: {}", accountBank);
            log.info("profileInfo: {}", profileInfo);
            log.info("logoImg: {}", logoImg != null ? logoImg.getOriginalFilename() : "null");
            log.info("existingLogoImg: {}", existingLogoImg);
            
            // DTO 생성
            StoreManagerUpdateDTO updateDTO = StoreManagerUpdateDTO.builder()
                    .storeDetail(storeDetail)
                    .account(account)
                    .accountBank(accountBank)
                    .profileInfo(profileInfo)
                    .build();
            
            // 서비스 호출
            int result = storeService.sellerInfoUpdate(
                    loginMember, storeUrl, updateDTO, logoImg, existingLogoImg);
            
            if (result > 0) {
                response.put("status", 200);
                response.put("message", "수정이 완료되었습니다.");
                response.put("data", result);
            } else {
                response.put("status", 400);
                response.put("message", "수정에 실패했습니다.");
            }
            
            return ResponseEntity.ok(response);
            
        } catch (IllegalArgumentException e) {
            log.error("잘못된 요청: ", e);
            response.put("status", 400);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
            
        } catch (Exception e) {
            log.error("판매자 정보 수정 실패", e);
            response.put("status", 500);
            response.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}