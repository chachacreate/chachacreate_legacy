package com.chacha.create.service.mainhome.personal;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.dto.product.PersonalProductDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.category.DCategoryMapper;
import com.chacha.create.common.mapper.category.TypeCategoryMapper;
import com.chacha.create.common.mapper.product.PersonalProductMapper;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class PersonalProductService {

    private final PersonalProductMapper personalProductMapper;
    private final TypeCategoryMapper typeCategoryMapper;
    private final DCategoryMapper dCategoryMapper;
    
    @Autowired
    private S3Uploader s3Uploader;

    /**
     * S3 Full URL에서 Key 추출하는 헬퍼 메서드
     */
    private String extractKeyFromUrl(String fullUrl) {
        if (fullUrl == null || fullUrl.isEmpty()) return null;
        
        // https://bucket-name.s3.amazonaws.com/images/original/uuid.webp → images/original/uuid.webp
        String[] parts = fullUrl.split(".s3.amazonaws.com/");
        return parts.length > 1 ? parts[1] : null;
    }

    /**
     * S3에서 original과 thumbnail 모두 삭제하는 헬퍼 메서드 (URL 기반)
     */
    private void deleteS3Images(String originalUrl) {
        if (originalUrl != null && !originalUrl.isEmpty()) {
            try {
                // Full URL에서 Key 추출
                String originalKey = extractKeyFromUrl(originalUrl);
                if (originalKey == null) return;
                
                // Original 이미지 삭제
                s3Uploader.delete(originalKey);
                log.info("S3 원본 이미지 삭제 성공: {}", originalKey);
                
                // Thumbnail 이미지 삭제
                String thumbnailKey = originalKey.replace("images/original/", "images/thumbnail/")
                                               .replace(".webp", "_thumb.webp");
                s3Uploader.delete(thumbnailKey);
                log.info("S3 썸네일 이미지 삭제 성공: {}", thumbnailKey);
                
            } catch (Exception e) {
                log.error("S3 이미지 삭제 중 오류 발생 - originalUrl: {}", originalUrl, e);
            }
        }
    }

    /**
     * 신규 등록용 이미지 처리 (Full URL 저장)
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertProductImages(PersonalProductDTO dto, MultipartFile image1, MultipartFile image2, MultipartFile image3) {
        int result = 0;
        
        try {
            if (image1 != null && !image1.isEmpty()) {
                String s3Key = s3Uploader.uploadImage(image1);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                dto.setPimgUrl1(fullUrl);
                result += personalProductMapper.insertMainProductImage(dto.getProductId(), 1, dto.getPimgUrl1());
                log.info("S3 이미지1 업로드 및 DB 저장 성공: {}", fullUrl);
            }
            
            if (image2 != null && !image2.isEmpty()) {
                String s3Key = s3Uploader.uploadImage(image2);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                dto.setPimgUrl2(fullUrl);
                result += personalProductMapper.insertMainProductImage(dto.getProductId(), 2, dto.getPimgUrl2());
                log.info("S3 이미지2 업로드 및 DB 저장 성공: {}", fullUrl);
            }
            
            if (image3 != null && !image3.isEmpty()) {
                String s3Key = s3Uploader.uploadImage(image3);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                dto.setPimgUrl3(fullUrl);
                result += personalProductMapper.insertMainProductImage(dto.getProductId(), 3, dto.getPimgUrl3());
                log.info("S3 이미지3 업로드 및 DB 저장 성공: {}", fullUrl);
            }
            
        } catch (Exception e) {
            log.error("S3 이미지 업로드 실패", e);
            throw new RuntimeException("이미지 업로드 중 오류가 발생했습니다.", e);
        }
        
        return result;
    }
    
    /**
     * 상품 등록 - MultipartFile 버전
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertMainProductWithImages(PersonalProductDTO dto, MemberEntity member,
                                          MultipartFile image1, MultipartFile image2, MultipartFile image3) {
        if(member == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        
        log.info(personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId()).toString());
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());
        dto.setSellerId(((BigDecimal)idMap.get("SELLER_ID")).intValue());
        dto.setStoreId(((BigDecimal)idMap.get("STORE_ID")).intValue());
        
        log.info(dto.toString());
        
        // 상품 정보 먼저 저장
        int result1 = personalProductMapper.insertMainProduct(dto);
        // 이미지 업로드 및 저장
        int result2 = insertProductImages(dto, image1, image2, image3);

        return (result1 > 0 && result2 >= 0) ? 1 : 0;
    }

    /**
     * 상품 조회 - 이제 URL 변환 불필요 (DB에 Full URL 저장됨)
     */
    public List<PersonalProductDTO> getProductsByMemberId(MemberEntity member) {
        if(member == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        
        log.info(personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId()).toString());
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());

        List<PersonalProductDTO> products = personalProductMapper.selectProductsByStoreId(((BigDecimal)idMap.get("STORE_ID")).intValue());
        
        // URL 변환 불필요 - DB에 이미 Full URL 저장됨
        log.info("상품 조회 완료, 총 {}개 상품", products.size());
        
        return products;
    }

    /**
     * 상품 수정 - MultipartFile 버전 (기존 이미지 original + thumbnail 삭제 후 업로드, Full URL 저장)
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateMainProductWithImages(PersonalProductDTO dto, MemberEntity member,
                                          MultipartFile image1, MultipartFile image2, MultipartFile image3) {
        if(member == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());
        dto.setSellerId(((BigDecimal)idMap.get("SELLER_ID")).intValue());
        dto.setStoreId(((BigDecimal)idMap.get("STORE_ID")).intValue());

        log.info("상품 수정 요청 - productId: {}, sellerId: {}, storeId: {}", 
            dto.getProductId(), idMap.get("SELLER_ID"), idMap.get("STORE_ID"));

        // 기존 상품 정보 조회 (기존 이미지 URL 확인용)
        PersonalProductDTO existingProduct = personalProductMapper.selectProductById(dto.getProductId());
        
        try {
            // 이미지 1 처리: 새 파일이 있으면 기존 original + thumbnail 삭제 후 업로드
            if (image1 != null && !image1.isEmpty()) {
                // 기존 이미지 삭제 (original + thumbnail)
                if (existingProduct != null) {
                    deleteS3Images(existingProduct.getPimgUrl1());
                }
                // 새 이미지 업로드 후 Full URL 저장
                String s3Key = s3Uploader.uploadImage(image1);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                dto.setPimgUrl1(fullUrl);
                log.info("새 S3 이미지1 업로드 성공: {}", fullUrl);
            }
            
            // 이미지 2 처리
            if (image2 != null && !image2.isEmpty()) {
                if (existingProduct != null) {
                    deleteS3Images(existingProduct.getPimgUrl2());
                }
                String s3Key = s3Uploader.uploadImage(image2);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                dto.setPimgUrl2(fullUrl);
                log.info("새 S3 이미지2 업로드 성공: {}", fullUrl);
            }
            
            // 이미지 3 처리
            if (image3 != null && !image3.isEmpty()) {
                if (existingProduct != null) {
                    deleteS3Images(existingProduct.getPimgUrl3());
                }
                String s3Key = s3Uploader.uploadImage(image3);
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                dto.setPimgUrl3(fullUrl);
                log.info("새 S3 이미지3 업로드 성공: {}", fullUrl);
            }
            
        } catch (Exception e) {
            log.error("S3 이미지 수정 중 실패", e);
            throw new RuntimeException("이미지 수정 중 오류가 발생했습니다.", e);
        }
        
        // 상품 정보 업데이트
        int result1 = personalProductMapper.updateMainProduct(dto);
        
        // 이미지 URL 업데이트 (새로 업로드한 이미지만)
        int result2 = 0;
        if(dto.getPimgUrl1() != null) {
            result2 += personalProductMapper.updateMainProductImage(dto.getProductId(), 1, dto.getPimgUrl1());
        }
        if(dto.getPimgUrl2() != null) {
            result2 += personalProductMapper.updateMainProductImage(dto.getProductId(), 2, dto.getPimgUrl2());
        }
        if(dto.getPimgUrl3() != null) {
            result2 += personalProductMapper.updateMainProductImage(dto.getProductId(), 3, dto.getPimgUrl3());
        }

        return (result1 > 0 || result2 > 0) ? 1 : 0;
    }

    /**
     * 상품 삭제 - S3 이미지 original + thumbnail 삭제 추가 (URL 기반)
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteMainProduct(int productId, MemberEntity member) {
        if(member == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        
        Map<String, Object> idMap = personalProductMapper.selectForSellerAndStoreByMemberId(member.getMemberId());
        int sellerId = ((BigDecimal)idMap.get("SELLER_ID")).intValue();
        int storeId = ((BigDecimal)idMap.get("STORE_ID")).intValue();
        
        int belongs = personalProductMapper.checkProductBelongsToSellerStore(productId, sellerId, storeId);
        if (belongs == 0) {
            log.warn("상품이 sellerId/storeId에 속하지 않음. 삭제 권한 없음.");
            return -2;
        }

        // S3에서 이미지 파일 삭제 (original + thumbnail)
        try {
            PersonalProductDTO existingProduct = personalProductMapper.selectProductById(productId);
            if (existingProduct != null) {
                // 각 이미지의 original + thumbnail 삭제 (URL 기반)
                deleteS3Images(existingProduct.getPimgUrl1());
                deleteS3Images(existingProduct.getPimgUrl2());
                deleteS3Images(existingProduct.getPimgUrl3());
            }
        } catch (Exception e) {
            log.error("S3 이미지 삭제 중 오류 발생", e);
        }

        int result = personalProductMapper.deleteMainProductById(productId);
        if (result > 0) {
            log.info("상품 ID {} 삭제 성공", productId);
            return 1;
        } else {
            log.warn("상품 ID {} 삭제 실패 또는 존재하지 않음", productId);
            return 0;
        }
    }
    
    /**
     * 카테고리 목록 조회
     */
    public Map<String, Object> categoryList(){
        Map<String, Object> categoryMap = new HashMap<String, Object>();
        categoryMap.put("typeCategory", typeCategoryMapper.selectAll());
        categoryMap.put("dCategoryMapper", dCategoryMapper.selectAll());
        return categoryMap;
    }
}