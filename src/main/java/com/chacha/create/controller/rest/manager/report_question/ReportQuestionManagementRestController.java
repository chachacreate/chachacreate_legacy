package com.chacha.create.controller.rest.manager.report_question;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.AlterMessageEntity;
import com.chacha.create.common.entity.store.QuestionEntity;
import com.chacha.create.common.entity.store.ReportEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.manager.report_question.ReportQuestionManagementService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/manager")
public class ReportQuestionManagementRestController {

    @Autowired
    private ReportQuestionManagementService reportManagementService;

    @GetMapping("/reports")
    public ResponseEntity<ApiResponse<List<ReportEntity>>> reportlist() {
        List<ReportEntity> reports = reportManagementService.selectForReportAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, reports));
    }

    @PostMapping("/altermessage")
    public ResponseEntity<ApiResponse<Integer>> altermessage(@RequestBody AlterMessageEntity alterMessageEntity) {
        log.info("altermessage : {}", alterMessageEntity);
        int result = reportManagementService.insert(alterMessageEntity);

        if (result > 0) {
            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                    .body(new ApiResponse<>(ResponseCode.CREATED, result));
        } else {
            return ResponseEntity.status(ResponseCode.INTERNAL_SERVER_ERROR.getStatus())
                    .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, 0));
        }
    }

    @GetMapping("/questions")
    public ResponseEntity<ApiResponse<List<QuestionEntity>>> questionlist() {
        List<QuestionEntity> questions = reportManagementService.selectForQuestionAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, questions));
    }
}

