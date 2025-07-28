package com.chacha.create.common.dto.member;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartViewDTO {
	// CartEntity
    private Integer cartId;
    private Integer memberId;
    private Integer productId;
    private Integer productCnt;
    
    // ProductEntity
    private String productName;
    private String productDetail;
    private Integer price;
    private Integer stock;
    
    // StoreEntity
    private Integer storeId;
    private String storeName;
    private String storeUrl;

    // PImgEntity
    private String pImgUrl;
}