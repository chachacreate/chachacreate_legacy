package com.chacha.create.common.mapper.product;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.dto.product.PersonalProductDTO;

@Mapper
public interface PersonalProductMapper {

	public int insertMainProduct(PersonalProductDTO dto);

	int insertMainProductImage(@Param("productId") int productId, @Param("seq") int seq, @Param("url") String url);

	int updateMainProductImage(@Param("productId") int productId, @Param("seq") int seq, @Param("url") String url);

	public Map<String, Object> selectForSellerAndStoreByMemberId(int memberId);

	public List<PersonalProductDTO> selectProductsByStoreId(Integer storeId);
	
	public int updateMainProduct(PersonalProductDTO dto);
    
    int deleteMainProductById(@Param("productId") int productId);
    
    // 해당 productId가 sellerId, storeId와 연관된지 여부 반환 (0=아님, 1=맞음)
    public int checkProductBelongsToSellerStore(
    	    @Param("productId") int productId,
    	    @Param("sellerId") int sellerId,
    	    @Param("storeId") int storeId);
    
    // 상품 정보 조회 (삭제 시 S3 이미지 URL 확인용)
    PersonalProductDTO selectProductById(@Param("productId") int productId);
}