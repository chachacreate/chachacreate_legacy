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
		
		// 각 상품의 이미지 URL을 S3 Full URL로 변환
		for (ProductlistDTO product : products) {
			if (product.getPimgUrl() != null && !product.getPimgUrl().isEmpty()) {
				product.setPimgUrl(s3Uploader.getFullUrl(product.getPimgUrl()));
			}
		}
		
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
	
	@Transactional(rollbackFor = Exception.class)
	public int productDeleteByEntities(List<ProductEntity> productList) {
	    int result = 0;

	    for (ProductEntity entity : productList) {
	        // S3에서 이미지 파일 삭제
	        List<PImgEntity> images = pimgMapper.selectByProductId(entity.getProductId());
	        for (PImgEntity image : images) {
	            if (image.getPimgUrl() != null && !image.getPimgUrl().isEmpty()) {
	                s3Uploader.delete(image.getPimgUrl());
	                log.info("S3 이미지 삭제: {}", image.getPimgUrl());
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
        
        // 이미지 URL을 S3 Full URL로 변환
        if (product != null) {
            if (product.getPimgUrl1() != null && !product.getPimgUrl1().isEmpty()) {
                product.setPimgUrl1(s3Uploader.getFullUrl(product.getPimgUrl1()));
            }
            if (product.getPimgUrl2() != null && !product.getPimgUrl2().isEmpty()) {
                product.setPimgUrl2(s3Uploader.getFullUrl(product.getPimgUrl2()));
            }
            if (product.getPimgUrl3() != null && !product.getPimgUrl3().isEmpty()) {
                product.setPimgUrl3(s3Uploader.getFullUrl(product.getPimgUrl3()));
            }
        }
        
        return product;
    }
    
    @Transactional
    public boolean updateProductDetailWithImages(String storeUrl, ProductUpdateDTO dto,
                                                 List<MultipartFile> images,
                                                 List<Integer> imageSeqs) {

        List<PImgEntity> existingImages = pimgMapper.selectByProductId(dto.getProductId());

        for (int i = 0; i < images.size(); i++) {
            MultipartFile file = images.get(i);
            int seq = imageSeqs.get(i);

            if (file.isEmpty()) continue;

            // 기존 이미지 S3에서 삭제
            existingImages.stream()
                .filter(img -> img.getPimgSeq() == seq)
                .findFirst()
                .ifPresent(img -> {
                    s3Uploader.delete(img.getPimgUrl());
                    pimgMapper.delete(img.getPimgId());
                    log.info("기존 S3 이미지 삭제: {}", img.getPimgUrl());
                });

            try {
                // S3에 새 이미지 업로드
                String s3Key = s3Uploader.uploadImage(file);
                
                PImgEntity image = PImgEntity.builder()
                    .productId(dto.getProductId())
                    .pimgUrl(s3Key)  // S3 Key 저장
                    .pimgEnum(ProductImageTypeEnum.THUMBNAIL)
                    .pimgSeq(seq)
                    .build();

                productimgInsert(image);
                log.info("S3 이미지 업로드 성공: {}", s3Key);

            } catch (Exception e) {
                log.error("S3 이미지 업로드 실패: {}", file.getOriginalFilename(), e);
                throw new RuntimeException("S3 이미지 업로드 실패", e);
            }
        }

        // 상품 정보 업데이트
        int updated = productDetailMapper.updateProduct(dto);
        return updated > 0;
    }
	
    @Transactional(rollbackFor = Exception.class)
    public int registerMultipleProductsWithImages(String storeUrl, List<ProductWithImagesDTO> requestList) {
        int successCount = 0;

        for (ProductWithImagesDTO request : requestList) {
            ProductEntity product = request.getProduct();
            List<MultipartFile> images = request.getImages();

            // 1. store_url → store_id 설정
            product.setStoreId(productMapper.selectForStoreIdByStoreUrl(storeUrl));

            // 2. 상품 등록
            int productInsertResult = productInsert(product);
            if (productInsertResult <= 0) {
                log.warn("❌ 상품 등록 실패: {}", product.getProductName());
                continue;
            }

            // 3. S3에 이미지 업로드 + DB 등록
            int seq = 1;
            int imgInsertCount = 0;

            for (MultipartFile file : images) {
                if (file.isEmpty()) continue;

                try {
                    // S3에 이미지 업로드
                    String s3Key = s3Uploader.uploadImage(file);

                    PImgEntity image = PImgEntity.builder()
                            .productId(product.getProductId())
                            .pimgUrl(s3Key)  // S3 Key 저장
                            .pimgEnum(ProductImageTypeEnum.THUMBNAIL)
                            .pimgSeq(seq++)
                            .build();

                    int result = productimgInsert(image);
                    if (result > 0) {
                        imgInsertCount++;
                        log.info("✅ S3 이미지 업로드 및 DB 저장 성공: {}", s3Key);
                    }

                } catch (Exception e) {
                    log.error("❌ S3 이미지 업로드 실패: {}", file.getOriginalFilename(), e);
                }
            }

            if (imgInsertCount == images.size()) {
                successCount++;
                log.info("✅ 상품 및 이미지 등록 성공: {}", product.getProductName());
            } else {
                log.warn("⚠️ 일부 이미지 등록 실패: {}", product.getProductName());
            }
        }

        return successCount;
    }
    
    public List<ProductEntity> getProductsByStore(String storeUrl) {
        int storeId = productMapper.selectForStoreIdByStoreUrl(storeUrl);
        if (storeId == 0) {
            log.warn("storeId가 0입니다. storeUrl: {}", storeUrl);
            return new ArrayList<>();
        }
        
        List<ProductEntity> products = productMapper.selectByStoreId(storeId);
        
        // 각 상품의 이미지 정보를 가져와서 S3 Full URL로 변환
        for (ProductEntity product : products) {
            List<PImgEntity> images = pimgMapper.selectByProductId(product.getProductId());
            for (PImgEntity image : images) {
                if (image.getPimgUrl() != null && !image.getPimgUrl().isEmpty()) {
                    image.setPimgUrl(s3Uploader.getFullUrl(image.getPimgUrl()));
                }
            }
        }
        
        return products;
    }
}