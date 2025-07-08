package com.chacha.create.service.seller.product;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ProductService {
	
	private final PImgMapper pimgMapper;
	private final ProductMapper productMapper;
	private final ProductManageMapper productDetailMapper;

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
		return productDetailMapper.selectAllByStoreUrl(storeUrl);
	}

	@Transactional(rollbackFor = Exception.class)
	public int updateFlagship(String storeUrl, List<ProductlistDTO> dtoList) {
	    int result = 0; // 총 업데이트된 행 수

	    for (ProductlistDTO dto : dtoList) {

	        if (dto.getFlagshipCheck() == 1) {
	            int count = productDetailMapper.countFlagshipByStoreId(storeUrl);
	            if (count >= 3) {
	                continue; // 업데이트 안 함
	            }
	        }

	        int updateCount = productDetailMapper.updateFlagship(dto); // 업데이트 시도
	        result += updateCount; // 총 업데이트 건수 누적
	    }
	    return result; // 전체 업데이트 건 수 반환
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int productDeleteByEntities(List<ProductEntity> productList) {
	    int result = 0; // 총 업데이트된 건수 누적

	    for (ProductEntity entity : productList) {
	        int updated = productDetailMapper.updateDeleteCheck(entity.getProductId());
	        if (updated > 0) {
	            log.info("상품 ID " + entity.getProductId() + " 논리 삭제 성공");
	            result += updated; // 누적
	        } else {
	        	log.info("상품 ID " + entity.getProductId() + " 이미 삭제되었거나 존재하지 않음");
	        }
	    }
	    return result; // 총 업데이트된 건수 반환
	}
	
    public ProductUpdateDTO getProductDetail(String storeUrl, int productId) {
        return productDetailMapper.updateProductDetail(storeUrl, productId);
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

            // 기존 이미지 삭제
            existingImages.stream()
                .filter(img -> img.getPimgSeq() == seq)
                .findFirst()
                .ifPresent(img -> {
                    deleteImageFile(img.getPimgUrl());
                    pimgMapper.delete(img.getPimgId());
                });

            try {
                String savedFileName = saveImageFile(file);
                PImgEntity image = PImgEntity.builder()
                    .productId(dto.getProductId())
                    .pimgUrl(savedFileName)
                    .pimgEnum(ProductImageTypeEnum.THUMBNAIL)
                    .pimgSeq(seq)
                    .build();

                productimgInsert(image);

            } catch (IOException e) {
                log.error("이미지 저장 실패: {}", file.getOriginalFilename(), e);
                throw new RuntimeException("이미지 저장 실패", e);
            }
        }

        // 상품 정보 업데이트
        int updated = productDetailMapper.updateProduct(dto);
        return updated > 0;
    }
	
    private boolean deleteImageFile(String pimgUrl) {
        if (pimgUrl == null || pimgUrl.isEmpty()) return false;
        
        try {
            String fileName = pimgUrl.substring(pimgUrl.lastIndexOf("/") + 1);
            Path filePath = Paths.get(imageSavePath, fileName);
            if (Files.exists(filePath)) {
                Files.delete(filePath);
                log.info("파일 삭제 성공: " + filePath);
                return true;
            } else {
                log.warn("삭제할 파일 없음: " + filePath);
                return false;
            }
        } catch (Exception e) {
            log.error("파일 삭제 중 오류 발생: ", e);
            return false;
        }
    }

	private final String imageSavePath = "C:/shinhan/install/springFramework/workSpace2/chacha_create1/"
			+ "src/main/webapp/resources/productImages";

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

            // 3. 이미지 저장 + DB 등록
            int seq = 1;
            int imgInsertCount = 0;

            for (MultipartFile file : images) {
                if (file.isEmpty()) continue;

                try {
                    String savedFileName = saveImageFile(file);
                    String imageUrl = savedFileName;

                    PImgEntity image = PImgEntity.builder()
                            .productId(product.getProductId())
                            .pimgUrl(imageUrl)
                            .pimgEnum(ProductImageTypeEnum.THUMBNAIL) // 전부 THUMBNAIL로
                            .pimgSeq(seq++) // 1부터 순차 증가
                            .build();

                    int result = productimgInsert(image);
                    if (result > 0) imgInsertCount++;

                } catch (IOException e) {
                    log.error("❌ 이미지 저장 실패: {}", file.getOriginalFilename(), e);
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

    private String saveImageFile(MultipartFile file) throws IOException {
        String originalFileName = file.getOriginalFilename();
        String extension = "";

        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }

        String newFileName = UUID.randomUUID().toString() + extension;

        Path uploadPath = Paths.get(imageSavePath);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(newFileName);
        file.transferTo(filePath.toFile());

        return newFileName;
    }
    
    public List<ProductEntity> getProductsByStore(String storeUrl) {
        int storeId = productMapper.selectForStoreIdByStoreUrl(storeUrl);
        if (storeId == 0) {
            log.warn("storeId가 0입니다. storeUrl: {}", storeUrl);
            return new ArrayList<>();
        }
        return productMapper.selectByStoreId(storeId);
    }
    
}