package com.chacha.create.common.mapper.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.dto.member.CartViewDTO;
import com.chacha.create.common.entity.member.CartEntity;

/**
 * cart 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface CartMapper {

    List<CartViewDTO> selectForCartViewList(int memberId);
    
    CartEntity selectForCartItem(
    		@Param("memberId") int memberId,
            @Param("productId") int productId
            );

    CartViewDTO selectForCartViewItem(
    		@Param("memberId") int memberId,
    		@Param("productId") int productId
    		);

    int insert(CartEntity entity);

    int updateForProductCnt(CartEntity entity);

    int deleteByCartId(int cartId);

    int deleteByMemberId(int memberId);
    
}