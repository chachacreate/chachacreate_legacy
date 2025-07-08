package com.chacha.create.common.dto.product;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ProductDetailViewDTO {
    private ProductDetailDTO productDetail;
    private List<String> thumbnailImageUrls;
    private List<String> descriptionImageUrls;
    private String mainThumbnailUrl;
}
