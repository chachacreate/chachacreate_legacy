package com.chacha.create.common.dto.product;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.entity.product.ProductEntity;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ProductWithImagesDTO {
	private ProductEntity product;

    // 컨트롤러에서 파일 분배할 때만 씀 (JSON에는 없음)
    private transient List<MultipartFile> images;

    // 프론트 최종 배열 그대로 받음
    @JsonProperty("descriptionUrls")
    private List<String> descriptionUrls;
}