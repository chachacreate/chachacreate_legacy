package com.chacha.create.controller.rest.manager.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.manager.member.MemberManagementService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/legacy/manager")
@Slf4j
public class MemberManagementRestController {

    @Autowired
    private MemberManagementService memberManagementService;

    @GetMapping("/users")
    public ResponseEntity<ApiResponse<List<MemberEntity>>> userlist() {
        List<MemberEntity> users = memberManagementService.selectAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, users));
    }

    @GetMapping("/userinfo")
    public ResponseEntity<ApiResponse<MemberEntity>> userinfo(@RequestParam int memberId) {
        MemberEntity member = memberManagementService.selectById(memberId);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, null));
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, member));
    }
}

