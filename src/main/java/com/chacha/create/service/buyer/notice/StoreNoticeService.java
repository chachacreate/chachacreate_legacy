package com.chacha.create.service.buyer.notice;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.chacha.create.common.mapper.store.NoticeMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StoreNoticeService {

	private final NoticeMapper noticeMapper;
	
	public List<Map<String, Object>> noticeList(String storeUrl){
		return noticeMapper.noticeList(storeUrl);
	}
	
	public List<Map<String, Object>> noticeDetailList(String storeUrl, int noticeId){ 
		return noticeMapper.noticeDetailList(storeUrl, noticeId);
	}
}
