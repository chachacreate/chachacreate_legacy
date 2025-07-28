package com.chacha.create.common.dto.product;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewManagementDTO {
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	
	private Date reviewDate;    // 리뷰 작성일

    private String pimgUrl;     // 대표 이미지
    private String productName; // 상품 이름
    private String memberName;  // 작성자 이름
    private String reviewText;  // 리뷰 내용
    private Date productDate;   // 상품 등록일
}
