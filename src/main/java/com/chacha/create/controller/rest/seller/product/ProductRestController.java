package com.chacha.create.controller.rest.seller.product;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.ProductUpdateDTO;
import com.chacha.create.common.dto.product.ProductWithImagesDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.entity.product.ProductEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.service.seller.order.OrderManagementService;
import com.chacha.create.service.seller.product.ProductService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/legacy/{storeUrl}/seller")
@Slf4j
public class ProductRestController {

	@Autowired
	private ProductService productService;
	
	@Autowired
	private OrderManagementService omService;

	// 상품 리스트 조회
	@GetMapping(value = "/products", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<List<ProductlistDTO>>> productlistjoin(@PathVariable String storeUrl) {
		List<ProductlistDTO> list = productService.productAllListByStoreUrl(storeUrl);
		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "상품 리스트 조회 성공", list));
	}

	// 대표 상품 수정
	@PutMapping(value = "/products", consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<Void>> updateFlagship(@PathVariable String storeUrl,
			@RequestBody List<ProductlistDTO> dtoList) {
		int result = productService.updateFlagship(storeUrl, dtoList);
		if (result > 0) {
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "대표 상품 수정 성공"));
		}
		return ResponseEntity.badRequest().body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "대표 상품 수정 실패"));
	}

	// 상품 삭제 (논리 삭제)
	@DeleteMapping(value = "/products", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> deleteFlagshipBatch(@RequestBody List<ProductEntity> productList) {
        int result = productService.productDeleteByEntities(productList);
        if (result > 0) {
            return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "상품 삭제 성공"));
        }
        return ResponseEntity.badRequest().body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "상품 삭제 실패"));
    }

	// 상품 입력
	@PostMapping(value = "/productinsert")
	public ResponseEntity<ApiResponse<Void>> insertProductWithImages(
	    @PathVariable String storeUrl,
	    @RequestParam("dtoList") String dtoListJson,
	    HttpServletRequest request
	) {
	    try {
	        log.info("상품 등록 요청 수신 - storeUrl: {}", storeUrl);
	        log.info("dtoList JSON: {}", dtoListJson);
	        
	        // 1. JSON 파싱
	        ObjectMapper mapper = new ObjectMapper();
	        List<ProductWithImagesDTO> requestList = mapper.readValue(dtoListJson, 
	            new TypeReference<List<ProductWithImagesDTO>>(){});
	        
	        // 2. 파일 처리
	        List<MultipartFile> allFiles = new ArrayList<>();
	        if (request instanceof MultipartHttpServletRequest) {
	            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
	            
	            // 모든 파일 키 확인
	            Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
	            log.info("업로드된 파일 키들: {}", fileMap.keySet());
	            
	            for (Map.Entry<String, MultipartFile> entry : fileMap.entrySet()) {
	                if (!entry.getKey().equals("dtoList") && !entry.getValue().isEmpty()) {
	                    allFiles.add(entry.getValue());
	                }
	            }
	        }
	        
	        log.info("처리할 파일 수: {}", allFiles.size());
	        
	        // 3. 파일을 각 상품에 분배
	        int fileIndex = 0;
	        for (int i = 0; i < requestList.size() && fileIndex < allFiles.size(); i++) {
	            ProductWithImagesDTO dto = requestList.get(i);
	            List<MultipartFile> productImages = new ArrayList<>();
	            
	            // 각 상품당 최대 3개 이미지
	            for (int j = 0; j < 3 && fileIndex < allFiles.size(); j++) {
	                MultipartFile file = allFiles.get(fileIndex);
	                if (!file.isEmpty()) {
	                    productImages.add(file);
	                }
	                fileIndex++;
	            }
	            
	            dto.setImages(productImages);
	        }
	        
	        // 4. 서비스 호출
	        int successCount = productService.registerMultipleProductsWithImages(storeUrl, requestList);
	        
	        // 5. 응답
	        if (successCount == requestList.size()) {
	            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
	                    .body(new ApiResponse<>(ResponseCode.CREATED, "모든 상품 등록 성공"));
	        } else if (successCount > 0) {
	            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
	                    .body(new ApiResponse<>(ResponseCode.CREATED, successCount + "개의 상품 등록 성공, 일부 실패"));
	        } else {
	            return ResponseEntity.badRequest()
	                    .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "상품 등록 실패"));
	        }
	        
	    } catch (Exception e) {
	        log.error("상품 등록 중 오류 발생", e);
	        return ResponseEntity.status(500)
	                .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, "서버 오류: " + e.getMessage()));
	    }
	}
	
	@GetMapping("/productupdate/{productId}")
	public ResponseEntity<ApiResponse<ProductUpdateDTO>> getProductDetail(@PathVariable String storeUrl,
			@PathVariable int productId) {
		ProductUpdateDTO product = productService.getProductDetail(storeUrl, productId);
		if (product != null) {
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "상품 상세 조회 성공", product));
		}
		return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
				.body(new ApiResponse<>(ResponseCode.NOT_FOUND, "해당 상품을 찾을 수 없습니다."));
	}
	/*
	@PutMapping("/productupdate/{productId}")
	public ResponseEntity<ApiResponse<Void>> updateProductDetail(@PathVariable String storeUrl,
			@PathVariable int productId, @RequestBody ProductUpdateDTO productUpdateDTO) {

		productUpdateDTO.setProductId(productId);

		if (productUpdateDTO.getPimgUrl1() == null)
			productUpdateDTO.setPimgUrl1("");
		if (productUpdateDTO.getPimgUrl2() == null)
			productUpdateDTO.setPimgUrl2("");
		if (productUpdateDTO.getPimgUrl3() == null)
			productUpdateDTO.setPimgUrl3("");
		
		boolean updated = productService.getProductDetail(storeUrl, productUpdateDTO);
		if (updated) {
			log.info("상품 수정 성공");
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "상품 수정 성공"));
		}
		log.info("상품 수정 실패");
		return ResponseEntity.badRequest().body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "상품 수정 실패"));
	}
	*/
	
	// 판매자 페이지 상품 수정 기능 
	@PostMapping("/productupdate/{productId}")
	public ResponseEntity<?> updateProduct(
	    @PathVariable String storeUrl,
	    @PathVariable int productId,
	    @RequestPart("dto") ProductUpdateDTO dto,
	    @RequestPart(value = "images", required = false) List<MultipartFile> images,
	    @RequestParam(value = "imageSeqs", required = false) List<Integer> imageSeqs
	) {
	    log.info("받은 productId: {}", dto.getProductId());

	    // null 방어
	    if (images == null) images = List.of();
	    if (imageSeqs == null) imageSeqs = List.of();

	    boolean success = productService.updateProductDetailWithImages(storeUrl, dto, images, imageSeqs);
	    return success ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
	}
	
	// 주문조회 중 환불요청을 완료로 업데이트
	@PutMapping(value = "/management/order", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<Void>> updateOrderStatus(@RequestBody OrderInfoEntity orderInfoEntity) {
	    int result = omService.updateForRefundStatus(orderInfoEntity);

	    if (result <= 0) {
	        throw new InvalidRequestException("주문 상태 수정 실패");
	    }

	    return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "주문 상태 수정 성공"));
	}
}