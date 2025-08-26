package com.chacha.create.controller.rest.buyer.report;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.ReportEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.report.ReportModalService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/{storeUrl}")
public class ReportModalRestController {
    
    @Autowired
    private ReportModalService reportModalService;
    
    @PostMapping("/reportinsert")
    public ResponseEntity<ApiResponse<String>> insertReport(@RequestBody ReportEntity reportEntity, HttpSession session) {
        log.info("신고 요청 데이터 : {}", reportEntity);

        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");

        int result = reportModalService.insert(loginMember, reportEntity);
        
        ResponseCode responseCode = result > 0 ? ResponseCode.CREATED : ResponseCode.BAD_REQUEST;
        String message = result == 1 ? "신고 등록 성공" : "신고 등록 실패";
        log.info(message);

        return ResponseEntity
                .status(responseCode.getStatus())
                .body(new ApiResponse<>(responseCode, message));
    }
}
