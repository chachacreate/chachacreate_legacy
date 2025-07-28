package com.chacha.create.common.entity.product;

import com.chacha.create.common.enums.image.ProductImageTypeEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상품 이미지 엔티티 클래스
 * <p>
 * DB의 {@code p_img} 테이블과 매핑되며,
 * 각 상품에 연결된 이미지 정보를 표현합니다.
 * </p>
 *
 * <pre>
 * 예시 데이터:
 * - pImgId: 101
 * - productId: 10
 * - pImgUrl: "/images/product123_thumb.jpg"
 * - pImgEnum: THUMBNAIL
 * - pImgSeq: 1
 * </pre>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PImgEntity {

    /** 상품 이미지 고유 ID (기본 키) */
    private Integer pimgId;

    /** 이미지가 속한 상품 ID (product 테이블의 외래키) */
    private Integer productId;

    /** 이미지 URL 경로 */
    private String pimgUrl;

    /** 이미지 타입 (예: 썸네일, 상세 설명 등, {@link ProductImageTypeEnum}) */
    private ProductImageTypeEnum pimgEnum;

    /** 이미지 순서 (정렬용 시퀀스 번호) */
    private Integer pimgSeq;
}