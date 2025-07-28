package com.chacha.create.controller.rest.seller.product;

import java.util.List;

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
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.ProductUpdateDTO;
import com.chacha.create.common.dto.product.ProductWithImagesDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;
import com.chacha.create.common.entity.product.ProductEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.seller.product.ProductService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/{storeUrl}/seller")
@Slf4j
public class ProductRestController {

	@Autowired
	private ProductService productService;

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
	@PostMapping(value = "/productinsert", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<ApiResponse<Void>> insertProductWithImages(@PathVariable String storeUrl,
	        @RequestBody List<ProductWithImagesDTO> requestList) {

	    int successCount = productService.registerMultipleProductsWithImages(storeUrl, requestList);

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
}