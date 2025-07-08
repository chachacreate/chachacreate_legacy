package com.chacha.create.service.mainhome.store;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StoreService {

	private final StoreMapper storeMapper;
	private final SellerMapper sellerMapper;
	
	@Transactional(rollbackFor = Exception.class)
	public int storeUpdate(StoreEntity storeEntity, MemberEntity memberEntity, boolean firstChk) {
    	if(memberEntity == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
		SellerEntity sellerEntity = sellerMapper.selectByMemberId(memberEntity.getMemberId()); // 로그인한 아이디로 seller를 가져옴
	
		// storeUrl 형식 검증: 영문/숫자/언더바만 허용, 길이 3~20
	    if (storeEntity.getStoreUrl() == null || !storeEntity.getStoreUrl().matches("^[a-zA-Z0-9_]{3,20}$")) {
	        throw new InvalidRequestException("스토어 URL은 영문, 숫자, 언더바(_)만 사용 가능하며 3~20자 이내여야 합니다.");
	    }
	    
	    StoreEntity existingStore = storeMapper.selectByStoreUrl(storeEntity.getStoreUrl());
	    if (existingStore != null) {
	        throw new InvalidRequestException("이미 사용 중인 스토어 URL입니다.");
	    }
		
		int sellerId = sellerEntity.getSellerId();
		
		storeEntity.setSellerId(sellerId); // seller 아이디로 스토어 정보를 추가 
		storeEntity.setStoreId(storeMapper.selectBySellerId(sellerId).getStoreId()); // seller 아이디로 스토어 아이디를 찾기
		log.info("store: {}", storeEntity);
		if(firstChk) {
			storeEntity.setSaleCnt(0);
			storeEntity.setViewCnt(0);
		}
		
		if(sellerEntity.getPersonalCheck() == 0 && storeEntity.getStoreUrl()!=null) {
			throw new InvalidRequestException("판매자는 스토어를 하나만 생성할 수 있습니다.");
		}else if(sellerEntity.getPersonalCheck() == 0 && storeEntity.getStoreUrl()==null) {
			throw new InvalidRequestException("개인판매자 등록을 먼저 해야됩니다.");
		}
		
		sellerMapper.updateBypersonalCheck(sellerId, 0);
		
		return storeMapper.update(storeEntity); // 정보 업데이트
	}
	
	public List<StoreEntity> selectAll() {
		return storeMapper.selectAll();
	}
	
	public boolean checkNotCreateable(MemberEntity memberEntity) {
		// 개인판매자면 false, 아니면 true
		int personalChk = sellerMapper.selectByMemberId(memberEntity.getMemberId()).getPersonalCheck();
		log.info("개인판매자 여부(1이면 개인판매자, 0이면 아님) : " + personalChk);
		return personalChk==0?true:false;
	}

	public boolean existsByStoreUrl(String storeUrl) {
		if(storeUrl.equalsIgnoreCase("main")) {
			//main을 넣으면 안되도록 설정
			return true;
		}
		return storeMapper.selectForCountUrlByStoreUrl(storeUrl)>0;
	}

	public boolean checkProductCount(MemberEntity loginMember) {
		Integer productCount = storeMapper.selectForCountProductByMemberId(loginMember.getMemberId());
		
		if(productCount == null) {
			return false; // 상품이 없을 때
		}
		
		log.info("로그인 사용자의 상품 개수 : " + productCount);
		return productCount<2;
	}
	
}
