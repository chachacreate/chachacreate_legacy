package com.chacha.create.common.dto.product;

import java.util.List;

import lombok.Data;

@Data
public class ProductForm {
    private List<ProductWithImagesDTO> dtoList;
}