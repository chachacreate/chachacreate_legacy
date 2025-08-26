package com.chacha.create.controller.rest.buyer.detail;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.ProductDetailViewDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.buyer.detail.ProductDetailService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/legacy/{storeUrl}")
public class ProductDetailRestController {

    @Autowired
    private ProductDetailService productDetailService;

    @GetMapping("/productdetail/{productId}")
    public ResponseEntity<ApiResponse<ProductDetailViewDTO>> getProductDetail(@PathVariable int productId) {
        ProductDetailViewDTO detail = productDetailService.getProductDetailWithImages(productId);
        if (detail == null) {
            // 상품이 없을 경우 404 응답 가능
            return ResponseEntity.status(ResponseCode.NOT_FOUND.getStatus())
                                 .body(new ApiResponse<>(ResponseCode.NOT_FOUND, null));
        }
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, detail));
    }
}