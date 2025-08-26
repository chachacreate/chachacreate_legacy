package com.chacha.create.controller.rest.buyer.notice;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.notice.StoreNoticeService;

@RestController
@RequestMapping("/legacy/{storeUrl}")
public class StoreNoticeRestController {

    @Autowired
    private StoreNoticeService storeNoticeService;

    @GetMapping("/notices")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> noticeList(@PathVariable String storeUrl) {
        List<Map<String, Object>> list = storeNoticeService.noticeList(storeUrl);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, list));
    }

    @GetMapping("/noticedetail/{noticeId}")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> noticeDetailList(@PathVariable String storeUrl, @PathVariable Integer noticeId) {
        List<Map<String, Object>> detail = storeNoticeService.noticeDetailList(storeUrl, noticeId);
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, detail));
    }
}
