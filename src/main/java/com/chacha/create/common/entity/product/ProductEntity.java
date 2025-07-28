package com.chacha.create.common.entity.product;

import java.sql.Date;

import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상품 정보를 나타내는 엔티티 클래스
 * <p>
 * DB의 {@code product} 테이블과 매핑되며,
 * 각 상품의 상세 정보를 담고 있습니다.
 * </p>
 *
 * <pre>
 * 필드 설명:
 * productId       : 상품 고유 ID (기본 키)
 * storeId         : 해당 상품을 등록한 상점 ID (외래키)
 * typeCategoryId  : 유형 카테고리 ID
 * dCategoryId     : 상세 카테고리 ID
 * productName     : 상품명
 * price           : 가격 (단위: 원)
 * productDetail   : 상품 상세 설명 (DB에서는 CLOB 타입으로 저장)
 * stock           : 재고 수량
 * productDate     : 상품 등록일자
 * saleCnt         : 판매 수량
 * viewCnt         : 조회 수
 * </pre>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductEntity{
    private Integer productId;
    private Integer storeId;
    private TypeCategoryEnum typeCategoryId;
    private DCategoryEnum dcategoryId;
    private String productName;

    private Integer price;

    /**
     * 상품 상세 설명 (DB에서는 CLOB 타입으로 저장)
     */
    private String productDetail;

    private Integer stock;
    private Date productDate;
    private Date lastModifiedDate;
    private Integer saleCnt;
    private Integer viewCnt;
    private Integer flagshipCheck;
    private Integer deleteCheck;
}