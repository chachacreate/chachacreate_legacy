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
public class ReviewDTO {
    
	// ReviewEntity
	private Integer reviewId;
    private Integer orderDetailId;
    
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date reviewDate;
    private String reviewText;
    
    // MemberEntity
    private Integer memberId;
    private String memberName;
    
    // ProductEntity
    private Integer productId;
    private String productName;
    
    // PImgEntity
    private String pImgUrl;
    
    // StoreEntity
    private String storeUrl;
}
