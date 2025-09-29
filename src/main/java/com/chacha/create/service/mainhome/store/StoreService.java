package com.chacha.create.service.mainhome.store;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.dto.boot.BootTokenDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.util.BootAPIUtil;
import com.chacha.create.util.s3.S3Uploader;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StoreService {
    
    private final StoreMapper storeMapper;
    private final SellerMapper sellerMapper;
    private final BootAPIUtil bootAPIUtil;
    
    @Autowired
    private S3Uploader s3Uploader;
    
    @Transactional(rollbackFor = Exception.class)
    public String storeUpdate(StoreEntity storeEntity, MemberEntity memberEntity, MultipartFile logoImg, boolean firstChk, HttpServletResponse response) {
        if(memberEntity == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        if(checkProductCount(memberEntity)) {
        	throw new InvalidRequestException("상품을 2개 등록해야합니다.");
        }
        
        SellerEntity sellerEntity = sellerMapper.selectByMemberId(memberEntity.getMemberId());
        BootTokenDTO token = bootAPIUtil.upgradePersonalSellerToSeller(sellerEntity.getMemberId(), response);
        
        // storeUrl 형식 검증: 영문/숫자/언더바만 허용, 길이 3~20
        if (storeEntity.getStoreUrl() == null || !storeEntity.getStoreUrl().matches("^[a-zA-Z0-9_]{3,20}$")) {
            throw new InvalidRequestException("스토어 URL은 영문, 숫자, 언더바(_)만 사용 가능하며 3~20자 이내여야 합니다.");
        }
        
        StoreEntity existingStore = storeMapper.selectByStoreUrl(storeEntity.getStoreUrl());
        if (existingStore != null) {
            throw new InvalidRequestException("이미 사용 중인 스토어 URL입니다.");
        }
        
        // 로고 이미지 S3 업로드
        if (logoImg != null && !logoImg.isEmpty()) {
            try {
                String s3Key = s3Uploader.uploadImage(logoImg);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                storeEntity.setLogoImg(fullUrl); // Full URL 저장
                log.info("스토어 로고 S3 업로드 성공: {}", fullUrl);
            } catch (Exception e) {
                log.error("스토어 로고 S3 업로드 실패", e);
                throw new RuntimeException("이미지 업로드 중 오류가 발생했습니다.", e);
            }
        }
        
        int sellerId = sellerEntity.getSellerId();
        
        storeEntity.setSellerId(sellerId);
        storeEntity.setStoreId(storeMapper.selectBySellerId(sellerId).getStoreId());
        log.info("store: {}", storeEntity);
        
        if(firstChk) {
            storeEntity.setSaleCnt(0);
            storeEntity.setViewCnt(0);
        }
        
        if(sellerEntity.getPersonalCheck() == 0 && storeEntity.getStoreUrl() != null) {
            throw new InvalidRequestException("판매자는 스토어를 하나만 생성할 수 있습니다.");
        } else if(sellerEntity.getPersonalCheck() == 0 && storeEntity.getStoreUrl() == null) {
            throw new InvalidRequestException("개인판매자 등록을 먼저 해야됩니다.");
        }
        
        sellerMapper.updateBypersonalCheck(sellerId, 0);
        storeMapper.update(storeEntity);
        log.info(token.toString());
        if(token.getAccessToken() == null || token.getAccessToken() == "") {
        	throw new InvalidRequestException("토큰 발급이 안되었습니다.");
        }
        return token.getAccessToken();
    }
    
    // 기존 메서드들은 그대로 유지
    public List<StoreEntity> selectAll() {
        return storeMapper.selectAll();
    }
    
    public boolean checkNotCreateable(MemberEntity memberEntity) {
        int personalChk = sellerMapper.selectByMemberId(memberEntity.getMemberId()).getPersonalCheck();
        log.info("개인판매자 여부(1이면 개인판매자, 0이면 아님) : " + personalChk);
        return personalChk == 0 ? true : false;
    }
    
    public boolean existsByStoreUrl(String storeUrl) {
        if(storeUrl.equalsIgnoreCase("main")) {
            return true;
        }
        return storeMapper.selectForCountUrlByStoreUrl(storeUrl) > 0;
    }
    
    public boolean checkProductCount(MemberEntity loginMember) {
        Integer productCount = storeMapper.selectForCountProductByMemberId(loginMember.getMemberId());
        
        if(productCount == null) {
            productCount = 0;
        }
        
        log.info("로그인 사용자의 상품 개수 : " + productCount);
        return productCount < 2;
    }

	public void click(int storeId) {
		storeMapper.updateClick(storeId);
		
	}
}