package com.chacha.create.controller.rest.seller.shut_down;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.boot.BootMemberDTO;
import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.shut_down.ShutDownService;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/{storeUrl}/seller")
@RequiredArgsConstructor
public class ShutDownRestController {

    private final ShutDownService shutDownService;
    private final BootAPIUtil bootAPIUtil;

    @PostMapping(value = "/close", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<String>> close(
            HttpSession session,
            @PathVariable("storeUrl") String storeUrl,
            @RequestBody MemberEntity memberEntity, HttpServletResponse response) {

        MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
        BootMemberDTO bootMember = bootAPIUtil.getBootMemberDataByMemberEmail(memberEntity.getMemberEmail());
        MemberEntity member = MemberEntity.builder()
        		.memberId(bootMember.getId().intValue())
        		.memberEmail(bootMember.getEmail())
        		.build();
        if (member != null && member.equals(loginMember)) {
            try {
                String accessToken = shutDownService.shutdown(loginMember.getMemberId(), storeUrl, response);
                if (accessToken != "") {
                    return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, accessToken));
                } else {
                    // 실패 시 409 Conflict 등 적절한 상태코드로 응답하는게 필요
                    return ResponseEntity.status(ResponseCode.CONFLICT.getStatus())
                            .body(new ApiResponse<>(ResponseCode.CONFLICT, ""));
                }
            } catch (IllegalStateException e) {
                log.error("폐업 시 오류 발생", e);
                return ResponseEntity.status(ResponseCode.INTERNAL_SERVER_ERROR.getStatus())
                        .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, ""));
            }
        } else {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, ""));
        }
    }
}
