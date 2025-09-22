// src/main/java/com/chacha/create/controller/rest/seller/notice/NoticeRestController.java
package com.chacha.create.controller.rest.seller.notice;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.NoticeEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.notice.NoticeService;
import com.chacha.create.service.store_common.MainService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/{storeUrl}/seller/management")
public class NoticeRestController {

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private MainService mainService;

    private MemberEntity getLoginMember(HttpSession session) {
        return (MemberEntity) session.getAttribute("loginMember");
    }

    /** 🔹 공지 목록: 로그인 요구 제거 + storeUrl 스코프 강제 */
    @GetMapping(value = "/notices", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<List<NoticeEntity>>> list(@PathVariable String storeUrl) {
        int storeId = mainService.storeIdCheck(storeUrl);
        if (storeId <= 0) {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "존재하지 않는 스토어"));
        }
        List<NoticeEntity> list = noticeService.selectByStoreId(storeId); // ✅ 스토어별 조회
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 목록 조회 성공", list));
    }

    /** 🔹 공지 상세: 로그인 요구 제거 + 소유 스토어 검증(선택) */
    @GetMapping(value = "/noticedetail/{noticeId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<NoticeEntity>> detail(@PathVariable String storeUrl,
                                                            @PathVariable int noticeId) {
        int storeId = mainService.storeIdCheck(storeUrl);
        if (storeId <= 0) {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "존재하지 않는 스토어"));
        }
        NoticeEntity notice = noticeService.selectByNoticeId(noticeId);
        if (notice == null || notice.getStoreId() != storeId) { // ✅ 다른 스토어 공지 차단
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "해당 공지사항을 찾을 수 없습니다."));
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 조회 성공", notice));
    }

    /** 🔹 공지 등록: CUD는 로그인 유지 */
    @PostMapping(value = "/noticeinsert", consumes = { MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_FORM_URLENCODED_VALUE }, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> insert(@PathVariable String storeUrl,
                                                    @RequestBody(required = false) NoticeEntity bodyJson,
                                                    HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }

        // JSON/Form 모두 대응
        NoticeEntity notice = bodyJson != null ? bodyJson : new NoticeEntity();
        int storeId = mainService.storeIdCheck(storeUrl);
        notice.setStoreId(storeId); // ✅ 스토어 강제 세팅

        int result = noticeService.insertNotice(notice, storeUrl);
        if (result > 0) {
            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.CREATED, "공지사항 등록 성공"));
        }
        return ResponseEntity.badRequest().body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "공지사항 등록 실패"));
    }

    /** 🔹 공지 수정 */
    @PutMapping(value = "/noticeupdate", consumes = { MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_FORM_URLENCODED_VALUE }, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> update(@PathVariable String storeUrl,
                                                    @RequestBody(required = false) NoticeEntity bodyJson,
                                                    HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }

        NoticeEntity notice = bodyJson != null ? bodyJson : new NoticeEntity();
        int storeId = mainService.storeIdCheck(storeUrl);
        notice.setStoreId(storeId); // ✅ 스토어 강제 세팅

        int result = noticeService.updateNotice(notice, storeUrl);
        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 수정 성공"));
        }
        return ResponseEntity.badRequest().body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "공지사항 수정 실패"));
    }

    /** 🔹 공지 삭제 */
    @DeleteMapping(value = "/noticedelete/{noticeId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable String storeUrl,
                                                    @PathVariable int noticeId,
                                                    HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }

        int storeId = mainService.storeIdCheck(storeUrl);
        NoticeEntity notice = noticeService.selectByNoticeId(noticeId);
        if (notice == null || notice.getStoreId() != storeId) {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "공지 없음 혹은 다른 스토어 소속"));
        }

        int result = noticeService.deleteNotice(noticeId);
        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 삭제 성공"));
        }
        return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "공지사항 삭제 실패 또는 존재하지 않음"));
    }

    /** 🔹 (선택) 스토어 공지 전용 엔드포인트 */
    @GetMapping(value = "/noticeselect", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<List<NoticeEntity>>> selectByStore(@PathVariable String storeUrl) {
        int storeId = mainService.storeIdCheck(storeUrl);
        List<NoticeEntity> result = noticeService.selectByStoreId(storeId);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }
}
