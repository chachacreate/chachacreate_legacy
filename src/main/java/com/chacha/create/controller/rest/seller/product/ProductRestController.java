package com.chacha.create.controller.rest.seller.product;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
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
import com.chacha.create.common.dto.order.UpdateOrderStatusRequestDTO;
import com.chacha.create.common.dto.product.ProductUpdateDTO;
import com.chacha.create.common.dto.product.ProductWithImagesDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.entity.product.ProductEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.exception.InvalidRequestException;
import com.chacha.create.service.seller.order.OrderManagementService;
import com.chacha.create.service.seller.product.ProductService;
import com.chacha.create.util.s3.S3Uploader;
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
	
	@Autowired
	private S3Uploader s3Uploader;

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
	public ResponseEntity<ApiResponse<Void>> toggleDeleteCheck(@RequestBody List<ProductEntity> productList) {
	    int result = productService.updateDeleteCheckBatch(productList);
	    if (result > 0) {
	        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "delete_check 토글(복구/삭제) 완료"));
	    }
	    return ResponseEntity.badRequest().body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "delete_check 토글 실패"));
	}

	// 상품 입력
	@PostMapping(
		    value = "/productinsert",
		    consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
		    produces = MediaType.APPLICATION_JSON_VALUE
		)
		public ResponseEntity<ApiResponse<Void>> insertProductWithImages(
		        @PathVariable String storeUrl,
		        @RequestPart(value = "dtoList", required = false) String dtoListJson, // ← RequestPart
		        @RequestParam(required = false) MultiValueMap<String, MultipartFile> fileMap,
		        MultipartHttpServletRequest request // 보정용
		) {
		    try {
		        // -------- dtoList 안전 보정 --------
		        if (dtoListJson == null || dtoListJson.isBlank()) {
		            dtoListJson = request.getParameter("dtoList"); // 폼필드로 도착한 경우
		        }
		        if (dtoListJson == null || dtoListJson.isBlank()) {
		            return ResponseEntity.badRequest()
		              .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "'dtoList' 파트가 없습니다."));
		        }

		        ObjectMapper mapper = new ObjectMapper();
		        List<ProductWithImagesDTO> requestList = mapper.readValue(
		            dtoListJson, new com.fasterxml.jackson.core.type.TypeReference<List<ProductWithImagesDTO>>() {}
		        );

		        if (fileMap == null) fileMap = new org.springframework.util.LinkedMultiValueMap<>();

		        // -------- 각 상품별 썸네일/설명 파일 매칭 --------
		        for (int pIdx = 0; pIdx < requestList.size(); pIdx++) {
		            ProductWithImagesDTO dto = requestList.get(pIdx);

		            // 썸네일 product{p}_image{n}
		            List<MultipartFile> thumbs = new ArrayList<>();
		            for (int n = 1; n <= 3; n++) {
		                MultipartFile f = first(fileMap, "product" + pIdx + "_image" + n);
		                if (f != null && !f.isEmpty()) thumbs.add(f);
		            }
		            dto.setImages(thumbs);

		            // 설명 product{p}_desc{n} → S3 업로드 & cid 치환
		            List<String> descUrls = new ArrayList<>();
		            String detail = Optional.ofNullable(dto.getProduct().getProductDetail()).orElse("");

		            for (int n = 1; ; n++) {
		                MultipartFile f = first(fileMap, "product" + pIdx + "_desc" + n);
		                if (f == null) break;
		                if (f.isEmpty()) continue;

		                String key = s3Uploader.uploadImage(f);     // 원본 업로드
		                String full = s3Uploader.getFullUrl(key);   // 풀 URL
		                descUrls.add(full);

		                String cid = "cid:desc-" + n;              // 본문 cid → url
		                detail = detail.replace(cid, full);
		            }

		            dto.getProduct().setProductDetail(detail);
		            dto.setDescriptionUrls(descUrls); // 서비스가 DESCRIPTION으로 저장
		        }

		        int success = productService.registerMultipleProductsWithImages(storeUrl, requestList);

		        if (success == requestList.size()) {
		            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
		                  .body(new ApiResponse<>(ResponseCode.CREATED, "모든 상품 등록 성공"));
		        } else if (success > 0) {
		            return ResponseEntity.status(ResponseCode.CREATED.getStatus())
		                  .body(new ApiResponse<>(ResponseCode.CREATED, success + "개의 상품 등록 성공, 일부 실패"));
		        } else {
		            return ResponseEntity.badRequest()
		                  .body(new ApiResponse<>(ResponseCode.BAD_REQUEST, "상품 등록 실패"));
		        }
		    } catch (Exception e) {
		        log.error("상품 등록 중 오류", e);
		        return ResponseEntity.status(500)
		              .body(new ApiResponse<>(ResponseCode.INTERNAL_SERVER_ERROR, "서버 오류: " + e.getMessage()));
		    }
		}

		private MultipartFile first(MultiValueMap<String, MultipartFile> map, String key) {
		    if (map == null) return null;
		    var list = map.get(key);
		    return (list == null || list.isEmpty()) ? null : list.get(0);
		}

    
	@GetMapping("/products/{productId}")
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
	
	 @PatchMapping(value = "/management/orders/{orderDetailId}/status", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	    public ApiResponse<Void> patchOrderStatus(@PathVariable("storeUrl") String storeUrl,
	                                              @PathVariable("orderDetailId") Integer orderDetailId,
	                                              @RequestBody UpdateOrderStatusRequestDTO request) {
	        log.info("주문 상태 변경 호출: storeUrl={}, orderId={}, toStatus={}", storeUrl, orderDetailId, request.getToStatus());

	        if (orderDetailId == null || request == null || request.getToStatus() == null || request.getToStatus().isBlank()) {
	            return new ApiResponse<>(ResponseCode.BAD_REQUEST, "orderId 또는 toStatus가 없습니다.");
	        }

	        final OrderStatusEnum toEnum;
	        try {
	            // 클라이언트는 Enum 코드(영문)를 보냄
	            toEnum = OrderStatusEnum.valueOf(request.getToStatus().trim());
	        } catch (IllegalArgumentException ex) {
	            return new ApiResponse<>(ResponseCode.BAD_REQUEST, "유효하지 않은 상태 코드입니다: " + request.getToStatus());
	        }

	        boolean updated = omService.updateOrderStatus(orderDetailId.intValue(), toEnum);
	        if (updated) {
	            return new ApiResponse<>(ResponseCode.OK, "주문 상태 변경 성공");
	        } else {
	            return new ApiResponse<>(ResponseCode.NOT_FOUND, "해당 주문을 찾을 수 없거나 변경 실패");
	        }
	    }
	
	
}