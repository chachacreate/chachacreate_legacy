package com.chacha.create.service.manager.report_question;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.entity.member.AlterMessageEntity;
import com.chacha.create.common.entity.store.QuestionEntity;
import com.chacha.create.common.entity.store.ReportEntity;
import com.chacha.create.common.mapper.member.AlterMessageMapper;
import com.chacha.create.common.mapper.store.QuestionMapper;
import com.chacha.create.common.mapper.store.ReportMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportQuestionManagementService {

	private final ReportMapper reportMapper;
	private final AlterMessageMapper alterMessageMapper;
	private final QuestionMapper questionMapper;
	
	public List<ReportEntity> selectForReportAll() {
		return reportMapper.selectAll();
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int insert(AlterMessageEntity alterMessageEntity) {
		return alterMessageMapper.insert(alterMessageEntity);
	}
	
	public List<QuestionEntity> selectForQuestionAll(){
		return questionMapper.selectAll();
	}
}
