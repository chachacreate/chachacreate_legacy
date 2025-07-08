package com.chacha.create.service.mainhome.question;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.QuestionEntity;
import com.chacha.create.common.mapper.store.QuestionMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class QuestionService {

	private final QuestionMapper questionMapper;
	
	public List<QuestionEntity> selectForQuestionAll(){
		return questionMapper.selectAll();
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int insertQuestion(MemberEntity memberEntity, QuestionEntity questionEntity) {
		questionEntity.setMemberId(memberEntity.getMemberId());
		log.info(questionEntity.toString());
		return questionMapper.insert(questionEntity);
	}
	
}
