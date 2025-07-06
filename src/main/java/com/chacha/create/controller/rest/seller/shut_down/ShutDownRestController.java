package com.chacha.create.controller.rest.seller.shut_down;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.shut_down.ShutDownService;
import com.chacha.create.service.store_common.header.auth.LoginService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/api/{storeUrl}/seller")
public class ShutDownRestController {

    @Autowired
    private ShutDownService shutDownService;

    @Autowired
    private LoginService loginService;

    @PutMapping(value = "/close", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Integer>> close(
            HttpSession session,
            @PathVariable("storeUrl") String storeUrl,
            @RequestBody MemberEntity memberEntity) {

        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        MemberEntity member = loginService.login(memberEntity.getMemberEmail(), memberEntity.getMemberPwd());

        if (member != null && member.equals(loginMember)) {
            try {
                int result = shutDownService.shutdown(storeUrl);
                if (result > 0) {
                    return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
                } else {
                    // �떎�뙣 �떆�뿏 409 Conflict �벑 �쟻�젅�븳 �긽�깭肄붾뱶濡� �쓳�떟�븯�뒗寃� 醫뗭븘�슂
                    return ResponseEntity.status(ResponseCode.CONFLICT.getStatus())
                            .body(new ApiResponse<>(ResponseCode.CONFLICT, 0));
                }
            } catch (IllegalStateException e) {
                log.error("�긽�젏 醫낅즺 以� �삤瑜� 諛쒖깮", e);
                return ResponseEntity.status(ResponseCode.INTERNAL_SERVER_ERROR.getStatus())
                        .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, 0));
            }
        } else {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, 0));
        }
    }
}
