package com.chacha.create.service.seller.product;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.dto.product.ProductUpdateDTO;
import com.chacha.create.common.dto.product.ProductWithImagesDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;
import com.chacha.create.common.entity.product.PImgEntity;
import com.chacha.create.common.entity.product.ProductEntity;
import com.chacha.create.common.enums.image.ProductImageTypeEnum;
import com.chacha.create.common.mapper.product.PImgMapper;
import com.chacha.create.common.mapper.product.ProductManageMapper;
import com.chacha.create.common.mapper.product.ProductMapper;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ProductService {
	
	private final PImgMapper pimgMapper;
	private final ProductMapper productMapper;
	private final ProductManageMapper productDetailMapper;
	
	@Autowired
	private S3Uploader s3Uploader;

	public int productimgInsert(PImgEntity p_imge) {
		return pimgMapper.insert(p_imge);
	}
	
	public int productimgUpdate(PImgEntity p_imge) {
		return pimgMapper.update(p_imge);
	}

	public int productInsert(ProductEntity product) {
		return productMapper.insert(product);
	}
	
	public List<ProductEntity> productlist(){
		return productMapper.selectAll();
	}
	
	public List<PImgEntity> pimglist(){
		return pimgMapper.selectAll();
	}
	
	public List<ProductlistDTO> productAllListByStoreUrl(String storeUrl){
		List<ProductlistDTO> products = productDetailMapper.selectAllByStoreUrl(storeUrl);
		
		// 이미 Full URL이 저장되어 있으므로 변환 불필요
		return products;
	}

	@Transactional(rollbackFor = Exception.class)
	public int updateFlagship(String storeUrl, List<ProductlistDTO> dtoList) {
	    int result = 0;

	    for (ProductlistDTO dto : dtoList) {
	        if (dto.getFlagshipCheck() == 1) {
	            int count = productDetailMapper.countFlagshipByStoreId(storeUrl);
	            if (count >= 3) {
	                continue;
	            }
	        }

	        int updateCount = productDetailMapper.updateFlagship(dto);
	        result += updateCount;
	    }
	    return result;
	}
	
	/**
	 * Full URL에서 S3 키를 추출하는 메서드
	 */
	private String extractS3KeyFromUrl(String fullUrl) {
	    try {
	        // Full URL에서 S3 키 추출
	        // 예: "https://bucket-name.s3.region.amazonaws.com/images/product/abc123.jpg" 
	        // -> "images/product/abc123.jpg"
	        String[] parts = fullUrl.split(".amazonaws.com/");
	        if (parts.length > 1) {
	            return parts[1];
	        }
	        return fullUrl; // 추출 실패 시 원본 반환
	    } catch (Exception e) {
	        log.error("S3 키 추출 실패: {}", fullUrl, e);
	        return fullUrl;
	    }
	}
	
	/**
	 * S3 키에서 썸네일 키를 생성하는 메서드
	 */
	private String generateThumbnailKey(String originalKey) {
	    // 원본: "images/product/abc123.jpg" -> 썸네일: "thumbnails/images/product/abc123.jpg"
	    return "thumbnails/" + originalKey;
	}
	
	/**
	 * 원본 이미지와 썸네일을 모두 삭제하는 메서드
	 */
	private void deleteImageWithThumbnail(String imageUrl) {
	    try {
	        // Full URL에서 S3 키 추출
	        String s3Key = extractS3KeyFromUrl(imageUrl);
	        
	        // 원본 이미지 삭제
	        s3Uploader.delete(s3Key);
	        log.info("S3 원본 이미지 삭제: {}", imageUrl);
	        
	        // 썸네일 이미지 삭제
	        String thumbnailKey = generateThumbnailKey(s3Key);
	        s3Uploader.delete(thumbnailKey);
	        log.info("S3 썸네일 이미지 삭제: {}", thumbnailKey);
	        
	    } catch (Exception e) {
	        log.error("S3 이미지 삭제 중 오류 발생: {}", imageUrl, e);
	    }
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int productDeleteByEntities(List<ProductEntity> productList) {
	    int result = 0;

	    for (ProductEntity entity : productList) {
	        // S3에서 이미지 파일 삭제 (원본 + 썸네일)
	        List<PImgEntity> images = pimgMapper.selectByProductId(entity.getProductId());
	        for (PImgEntity image : images) {
	            if (image.getPimgUrl() != null && !image.getPimgUrl().isEmpty()) {
	                deleteImageWithThumbnail(image.getPimgUrl());
	            }
	        }
	        
	        int updated = productDetailMapper.updateDeleteCheck(entity.getProductId());
	        if (updated > 0) {
	            log.info("상품 ID " + entity.getProductId() + " 논리 삭제 성공");
	            result += updated;
	        } else {
	        	log.info("상품 ID " + entity.getProductId() + " 이미 삭제되었거나 존재하지 않음");
	        }
	    }
	    return result;
	}
	
    public ProductUpdateDTO getProductDetail(String storeUrl, int productId) {
        ProductUpdateDTO product = productDetailMapper.updateProductDetail(storeUrl, productId);
        
        // 이미 Full URL이 저장되어 있으므로 변환 불필요
        return product;
    }
    
    @Transactional
    public boolean updateProductDetailWithImages(String storeUrl, ProductUpdateDTO dto,
                                                 List<MultipartFile> images,
                                                 List<Integer> imageSeqs) {

        // 기존 이미지 정보 조회
        List<PImgEntity> existingImages = pimgMapper.selectByProductId(dto.getProductId());

        // 이미지 업데이트 처리
        for (int i = 0; i < images.size(); i++) {
            MultipartFile file = images.get(i);
            int seq = imageSeqs.get(i);

            if (file.isEmpty()) continue;

            // 1. 기존 이미지 S3에서 삭제 (원본 + 썸네일) 및 DB에서 삭제
            existingImages.stream()
                .filter(img -> img.getPimgSeq() == seq)
                .findFirst()
                .ifPresent(img -> {
                    deleteImageWithThumbnail(img.getPimgUrl());
                    pimgMapper.delete(img.getPimgId());
                    log.info("기존 이미지 삭제 완료 - S3 및 DB: pimgId={}, url={}", 
                            img.getPimgId(), img.getPimgUrl());
                });

            try {
                // 2. S3에 새 이미지 업로드 
                String s3Key = s3Uploader.uploadImage(file);
                // 3. S3 키를 Full URL로 변환
                String fullUrl = s3Uploader.getFullUrl(s3Key);
                log.info("새 이미지 S3 업로드 완료 - Key: {}, Full URL: {}", s3Key, fullUrl);

                // 4. DB에 새 이미지 정보 삽입 (Full URL 저장)
                PImgEntity newImage = PImgEntity.builder()
                    .productId(dto.getProductId())
                    .pimgUrl(fullUrl)  // Full URL 저장
                    .pimgEnum(ProductImageTypeEnum.THUMBNAIL)
                    .pimgSeq(seq)
                    .build();
                
                int insertResult = productimgInsert(newImage);
                log.info("새 이미지 DB 삽입 완료 - productId={}, seq={}, fullUrl={}, insertResult={}", 
                        dto.getProductId(), seq, fullUrl, insertResult);

            } catch (Exception e) {
                log.error("S3 이미지 업로드 실패: {}", file.getOriginalFilename(), e);
                throw new RuntimeException("S3 이미지 업로드 실패", e);
            }
        }

        // 5. 상품 정보 업데이트 (이미지 외 정보도 함께)
        int updated = productDetailMapper.updateProduct(dto);
        log.info("상품 정보 업데이트 완료: productId={}, updateResult={}", dto.getProductId(), updated);
        
        return updated > 0;
    }
	
    @Transactional(rollbackFor = Exception.class)
    public int registerMultipleProductsWithImages(String storeUrl,
                                                 List<ProductWithImagesDTO> requestList) {
        if (storeUrl == null || storeUrl.isBlank() || requestList == null || requestList.isEmpty()) {
            log.warn("❌ 상품 등록 실패: 잘못된 입력 (storeUrl={}, size={})",
                     storeUrl, (requestList == null ? null : requestList.size()));
            return 0;
        }

        final int storeId = productMapper.selectForStoreIdByStoreUrl(storeUrl);
        if (storeId <= 0) {
            log.warn("❌ 상품 등록 실패: storeId 조회 실패 (storeUrl={})", storeUrl);
            return 0;
        }

        int successCount = 0;

        for (int idx = 0; idx < requestList.size(); idx++) {
            ProductWithImagesDTO req = requestList.get(idx);
            if (req == null || req.getProduct() == null) {
                log.warn("⚠️ [{}] DTO 또는 product 가 null", idx);
                continue;
            }

            ProductEntity product = req.getProduct();
            product.setStoreId(storeId);

            // 상품 insert
            int ins = productInsert(product); // ← 기존 그대로 (Mapper 통해 insert)
            if (ins <= 0) {
                log.warn("❌ [{}] 상품 insert 실패: name={}", idx, product.getProductName());
                continue;
            }
            final int productId = product.getProductId();

            // 썸네일 (최대 3장)
            List<MultipartFile> images = req.getImages();
            if (images != null && !images.isEmpty()) {
                int seq = 1;
                int limit = Math.min(images.size(), 3);
                for (int i = 0; i < limit; i++) {
                    MultipartFile f = images.get(i);
                    if (f == null || f.isEmpty()) continue;
                    try {
                        String key = s3Uploader.uploadImage(f);
                        String url = s3Uploader.getFullUrl(key);

                        PImgEntity thumb = PImgEntity.builder()
                                .productId(productId)
                                .pimgUrl(url)
                                .pimgEnum(ProductImageTypeEnum.THUMBNAIL)
                                .pimgSeq(seq++)
                                .build();

                        // ✅ Mapper 직접 호출
                        pimgMapper.insert(thumb);
                    } catch (Exception e) {
                        log.error("❌ [{}] 썸네일 업로드/저장 실패(i={}): {}", idx, i, e.getMessage(), e);
                    }
                }
            }

            // 설명 이미지 (프론트에서 보내준 최종 S3 URL)
            List<String> descriptionUrls = req.getDescriptionUrls();
            if (descriptionUrls != null && !descriptionUrls.isEmpty()) {
                int dSeq = 1;
                java.util.LinkedHashSet<String> uniq = new java.util.LinkedHashSet<>(descriptionUrls);
                for (String raw : uniq) {
                    if (raw == null) continue;
                    String url = raw.trim();
                    if (url.isEmpty()) continue;
                    if (url.length() > 500) {
                        log.warn("⚠️ [{}] DESCRIPTION URL 길이 초과 스킵: {}", idx, url);
                        continue;
                    }

                    PImgEntity desc = PImgEntity.builder()
                            .productId(productId)
                            .pimgUrl(url)
                            .pimgEnum(ProductImageTypeEnum.DESCRIPTION)
                            .pimgSeq(dSeq++)
                            .build();

                    // ✅ Mapper 직접 호출
                    pimgMapper.insert(desc);
                }
            }

            successCount++;
        }

        log.info("📦 상품 일괄 등록 결과: 요청 {}개 중 {}개 성공", requestList.size(), successCount);
        return successCount;
    }

    
    public List<ProductEntity> getProductsByStore(String storeUrl) {
        int storeId = productMapper.selectForStoreIdByStoreUrl(storeUrl);
        if (storeId == 0) {
            log.warn("storeId가 0입니다. storeUrl: {}", storeUrl);
            return new ArrayList<>();
        }
        
        List<ProductEntity> products = productMapper.selectByStoreId(storeId);
        
        // 이미 Full URL이 저장되어 있으므로 변환 불필요
        return products;
    }
}