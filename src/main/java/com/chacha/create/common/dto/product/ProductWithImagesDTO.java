package com.chacha.create.common.dto.product;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.entity.product.ProductEntity;
import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductWithImagesDTO {
    private ProductEntity product;
    
    @JsonIgnore
    private List<MultipartFile> images;
}