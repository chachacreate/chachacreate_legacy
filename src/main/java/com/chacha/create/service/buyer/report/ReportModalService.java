package com.chacha.create.service.buyer.report;

import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.store.ReportEntity;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.store.ReportMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReportModalService {
	
	private final ReportMapper reportMapper;
	private final StoreMapper storeMapper;
	
	@Transactional(rollbackFor = Exception.class)
	public int insert(MemberEntity loginMember, ReportEntity reportEntity) {
    	if(loginMember == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	
		// 판매자를 신고할 경우 로그인된 사용자 정보 등록
    	// 리뷰를 신고할 경우에는 memberId가 할당되어 오므로 X
    	if (reportEntity.getMemberId() == null) {
    	    reportEntity.setMemberId(loginMember.getMemberId());
    	}

	    // 스토어 ID로 판매자 ID 조회
	    Integer storeId = reportEntity.getStoreId();
	    Integer sellerId = storeMapper.selectForSellerIdByStoreId(storeId);
	    reportEntity.setSellerId(sellerId);
	    log.info("storeID : {} sellserID : {}",storeId,sellerId);
	    // 현재 날짜 저장
	    reportEntity.setReportDate(new Date());

	    log.info("최종 insert 데이터 : {}", reportEntity);
		return reportMapper.insert(reportEntity);
	}

}
