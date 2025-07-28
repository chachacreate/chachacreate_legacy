package com.chacha.create.service.seller.notice;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.entity.store.NoticeEntity;
import com.chacha.create.common.mapper.store.NoticeMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class NoticeService {

	private final NoticeMapper noticeMapper;
	private final StoreMapper storeMapper;
	
	public List<NoticeEntity> selectForNoticeAll(){
		return noticeMapper.selectAll();
	}
	
	public NoticeEntity selectByNoticeId(int noticeId){
		return noticeMapper.selectByNoticeId(noticeId);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int insertNotice(NoticeEntity noticeEntity, String storeUrl) {
		noticeEntity.setStoreId(storeMapper.selectByStoreUrl(storeUrl).getStoreId());
		return noticeMapper.insert(noticeEntity);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int updateNotice(NoticeEntity noticeEntity, String storeUrl) {
		noticeEntity.setStoreId(storeMapper.selectByStoreUrl(storeUrl).getStoreId());
		return noticeMapper.update(noticeEntity);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int deleteNotice(int noticeId) {
		return noticeMapper.delete(noticeId);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public List<NoticeEntity> selectByStoreId(int storeId) {
		return noticeMapper.selectByStoreId(storeId);
	}
	
}
