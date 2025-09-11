package com.chacha.create.common.mapper.product;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.dto.product.ProductDetailDTO;
import com.chacha.create.common.dto.product.ProductUpdateDTO;
import com.chacha.create.common.dto.product.ProductlistDTO;

@Mapper
public interface ProductManageMapper {
	ProductUpdateDTO updateProductDetail(@Param("storeUrl") String storeUrl,
            @Param("productId") int productId);
	
	int updateProduct(ProductUpdateDTO dto);
	int updateProductImages(ProductUpdateDTO dto);
	
	ProductDetailDTO selectByProductId(int productId);
	int countFlagshipByStoreId(String storeUrl);
	List<ProductlistDTO> selectAllByStoreUrl(String storeUrl);
	int updateFlagship(ProductlistDTO productlistDTO);
	int updateDeleteCheck(int productId);

	int updateDeleteCheckById(Map<String, Object> param);
	
	ProductDetailDTO selectProductWithThumbnail(int productId);
}
