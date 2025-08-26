package com.chacha.create.controller.rest.seller.notice;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    
    @GetMapping(value = "/notices", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<List<NoticeEntity>>> noticelist(@PathVariable String storeUrl, HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }
        List<NoticeEntity> list = noticeService.selectForNoticeAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 목록 조회 성공", list));
    }

    @GetMapping(value = "/noticedetail/{noticeId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<NoticeEntity>> noticedetail(@PathVariable String storeUrl, @PathVariable int noticeId, HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }
        NoticeEntity notice = noticeService.selectByNoticeId(noticeId);
        if (notice == null) {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "해당 공지사항을 찾을 수 없습니다."));
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 조회 성공", notice));
    }

    @PostMapping(value = "/noticeinsert", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> insertNotice(@PathVariable String storeUrl, @RequestBody NoticeEntity noticeEntity, HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }

        int result = noticeService.insertNotice(noticeEntity, storeUrl);
        if (result > 0) {
            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.CREATED, "공지사항 등록 성공"));
        } else {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "공지사항 등록 실패"));
        }
    }

    @PutMapping(value = "/noticeupdate", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> updateNotice(@PathVariable String storeUrl, @RequestBody NoticeEntity noticeEntity, HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }

        int result = noticeService.updateNotice(noticeEntity, storeUrl);
        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 수정 성공"));
        } else {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "공지사항 수정 실패"));
        }
    }

    @DeleteMapping(value = "/noticedelete/{noticeId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> deleteNotice(@PathVariable String storeUrl, @PathVariable int noticeId, HttpSession session) {
        MemberEntity member = getLoginMember(session);
        if (member == null) {
            return ResponseEntity.status(ResponseCode.UNAUTHORIZED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.UNAUTHORIZED, "로그인이 필요합니다."));
        }

        int result = noticeService.deleteNotice(noticeId);
        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "공지사항 삭제 성공"));
        } else {
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                    .body(new ApiResponse<>(ResponseCode.NOT_FOUND, "공지사항 삭제 실패 또는 존재하지 않음"));
        }
    }
    
    // 특정 스토의 공지사항 조회 
    @GetMapping("/noticeselect")
    public ResponseEntity<ApiResponse<List<NoticeEntity>>> selectByStoreId(@PathVariable String storeUrl){
    			int storeId = mainService.storeIdCheck(storeUrl);
    			List<NoticeEntity> result = noticeService.selectByStoreId(storeId);
    		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
    }
}
