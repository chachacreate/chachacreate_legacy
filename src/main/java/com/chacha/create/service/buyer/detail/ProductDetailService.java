package com.chacha.create.service.buyer.detail;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.product.ProductDetailDTO;
import com.chacha.create.common.dto.product.ProductDetailViewDTO;
import com.chacha.create.common.entity.product.PImgEntity;
import com.chacha.create.common.enums.image.ProductImageTypeEnum;
import com.chacha.create.common.mapper.product.PImgMapper;
import com.chacha.create.common.mapper.product.ProductManageMapper;
import com.chacha.create.util.s3.S3Uploader;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductDetailService {
	
	private final PImgMapper pImgMapper;
	private final ProductManageMapper productDetailMapper;
	
	@Autowired
	private S3Uploader s3Uploader;
	
	@Transactional(rollbackFor = Exception.class)
	public ProductDetailViewDTO getProductDetailWithImages(int productId) {
	    ProductDetailDTO productDetail = productDetailMapper.selectByProductId(productId);
	    List<PImgEntity> pImgList = pImgMapper.selectByProductId(productId);
	    
	    List<String> thumbnailUrls = new ArrayList<>();
	    List<String> descriptionUrls = new ArrayList<>();
	    String mainThumbnailUrl = null;
	    int minSeq = Integer.MAX_VALUE;
	    
	    for (PImgEntity img : pImgList) {
	        String fullUrl = img.getPimgUrl();
	        
	        // S3 Key를 Full URL로 변환
//	        if (img.getPimgUrl() != null && !img.getPimgUrl().isEmpty()) {
//	            fullUrl = s3Uploader.getFullUrl(img.getPimgUrl());
//	        }
	        
	        if (ProductImageTypeEnum.THUMBNAIL.equals(img.getPimgEnum())) {
	            if (fullUrl != null) {
	                thumbnailUrls.add(fullUrl);
	            }
	            
	            // 가장 작은 seq를 가진 썸네일을 메인으로 설정
	            if (img.getPimgSeq() != null && img.getPimgSeq() < minSeq) {
	                minSeq = img.getPimgSeq();
	                mainThumbnailUrl = fullUrl;
	            }
	        } else if (ProductImageTypeEnum.DESCRIPTION.equals(img.getPimgEnum())) {
	            if (fullUrl != null) {
	                descriptionUrls.add(fullUrl);
	            }
	        }
	    }
	    
	    ProductDetailViewDTO productDetailViewDTO = ProductDetailViewDTO.builder()
	    		.productDetail(productDetail)
	    	    .thumbnailImageUrls(thumbnailUrls)
	    	    .descriptionImageUrls(descriptionUrls)
	    	    .mainThumbnailUrl(mainThumbnailUrl)
	    	    .build();
	    
	    log.info("상품 상세 조회 완료 - Product ID: {}, 썸네일 수: {}, 설명 이미지 수: {}", 
	             productId, thumbnailUrls.size(), descriptionUrls.size());
	    
	    return productDetailViewDTO;
	}
}