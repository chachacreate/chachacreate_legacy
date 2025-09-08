package com.chacha.create.service.manager.store;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.chacha.create.common.dto.manager.StoreManagerUpdateDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.member.SellerEntity;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.mapper.member.SellerMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.util.s3.S3Uploader;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class StoreManagementUpdateService {
	
	private final StoreMapper storeMapper;
    private final SellerMapper sellerMapper;
    private final S3Uploader s3Uploader;
	
    @Transactional(rollbackFor = Exception.class)
	public int sellerInfoUpdate(MemberEntity loginMember, String storeUrl, StoreManagerUpdateDTO smuDTO, 
	                           MultipartFile logoImg, String existingLogoImg) {
		log.info("Store URL: {}", storeUrl);
		log.info("Login Member: {}", loginMember.toString());
		log.info("Update DTO: {}", smuDTO.toString());
		
    	int result = 0;
    	String finalLogoUrl = null;
    	
		// 기존 스토어 정보 조회
		StoreEntity userStore = storeMapper.selectByStoreUrl(storeUrl);
		log.info("Current Store: {}", userStore.toString());
		
		// 로고 이미지 처리
		try {
			if (logoImg != null && !logoImg.isEmpty()) {
				// 새로운 이미지가 업로드된 경우
				log.info("새로운 로고 이미지 업로드 시작");
				
				// 기존 이미지 삭제 (S3에서)
				if (userStore.getLogoImg() != null && !userStore.getLogoImg().isEmpty()) {
					// Full URL에서 S3 key 추출
					String existingKey = extractS3KeyFromUrl(userStore.getLogoImg());
					if (existingKey != null) {
						int deleteResult = s3Uploader.delete(existingKey);
						log.info("기존 로고 이미지 삭제 결과: {}", deleteResult);
						
						// 썸네일도 삭제
						String thumbnailKey = existingKey.replace("images/original/", "images/thumbnail/")
								.replace(".webp", "_thumb.webp");
						s3Uploader.delete(thumbnailKey);
						log.info("기존 썸네일 이미지 삭제 완료");
					}
				}
				
				// 새 이미지 업로드
				String s3Key = s3Uploader.uploadImage(logoImg);
				finalLogoUrl = s3Uploader.getFullUrl(s3Key);
				log.info("새 로고 이미지 업로드 완료. URL: {}", finalLogoUrl);
				
			} else if (existingLogoImg != null && !existingLogoImg.isEmpty()) {
				// 기존 이미지 유지
				finalLogoUrl = userStore.getLogoImg();
				log.info("기존 로고 이미지 유지: {}", finalLogoUrl);
				
			} else {
				// 기존 이미지 유지 (아무것도 전달되지 않은 경우)
				finalLogoUrl = userStore.getLogoImg();
				log.info("로고 이미지 변경 없음");
			}
			
		} catch (Exception e) {
			log.error("로고 이미지 처리 중 오류 발생", e);
			throw new RuntimeException("로고 이미지 업로드 실패: " + e.getMessage());
		}
		
		// 스토어 엔티티 생성
		StoreEntity storeEntity = StoreEntity.builder()
				.storeId(userStore.getStoreId())
				.logoImg(finalLogoUrl)
				.storeName(userStore.getStoreName())
				.storeDetail(smuDTO.getStoreDetail())
				.build();
		
		// 판매자 엔티티 생성
		SellerEntity sellerEntity = SellerEntity.builder()
				.sellerId(userStore.getSellerId())
				.account(smuDTO.getAccount())
				.accountBank(smuDTO.getAccountBank())
				.profileInfo(smuDTO.getProfileInfo())
				.build();
		
		log.info("최종 스토어 엔티티: {}", storeEntity);
		log.info("최종 판매자 엔티티: {}", sellerEntity);
		
		// DB 업데이트
		result += storeMapper.updateStoreInfo(storeEntity);
		result += sellerMapper.updateSellerInfo(sellerEntity);
		
		log.info("업데이트 결과: {}", result);
		return result;
	}
	
	/**
	 * S3 Full URL에서 Key 추출
	 * @param fullUrl S3 Full URL
	 * @return S3 Key 또는 null
	 */
	private String extractS3KeyFromUrl(String fullUrl) {
		if (fullUrl == null || fullUrl.isEmpty()) {
			return null;
		}
		
		try {
			// https://bucket-name.s3.amazonaws.com/images/original/filename.webp
			// -> images/original/filename.webp
			if (fullUrl.contains(".s3.amazonaws.com/")) {
				String[] parts = fullUrl.split(".s3.amazonaws.com/");
				if (parts.length > 1) {
					return parts[1];
				}
			}
			
			// 다른 S3 URL 형식도 고려
			if (fullUrl.contains("amazonaws.com/")) {
				int index = fullUrl.indexOf("amazonaws.com/");
				if (index != -1) {
					return fullUrl.substring(index + "amazonaws.com/".length());
				}
			}
			
			return null;
		} catch (Exception e) {
			log.error("S3 URL에서 Key 추출 실패: {}", fullUrl, e);
			return null;
		}
	}
}