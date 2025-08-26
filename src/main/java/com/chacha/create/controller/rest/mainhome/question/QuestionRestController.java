package com.chacha.create.controller.rest.mainhome.question;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.QuestionEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.mainhome.question.QuestionService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy/main")
public class QuestionRestController {

    @Autowired
    private QuestionService questionService;

    @GetMapping("/question")
    public ResponseEntity<ApiResponse<List<QuestionEntity>>> getQuestionList() {
        List<QuestionEntity> questions = questionService.selectForQuestionAll();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, questions));
    }

    @PostMapping("/question")
    public ResponseEntity<ApiResponse<Integer>> insertQuestion(@RequestBody QuestionEntity questionEntity, HttpSession session) {
        MemberEntity memberEntity = (MemberEntity) session.getAttribute("loginMember");
        log.info("질문 등록 요청 - member: {}, question: {}", memberEntity, questionEntity);
        int result = questionService.insertQuestion(memberEntity, questionEntity);
        return ResponseEntity.status(ResponseCode.CREATED.getStatus())
                             .body(new ApiResponse<>(ResponseCode.CREATED, result));
    }
}