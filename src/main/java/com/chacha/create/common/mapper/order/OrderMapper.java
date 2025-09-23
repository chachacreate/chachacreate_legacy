package com.chacha.create.common.mapper.order;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.dto.order.OrderDetailDTO;
import com.chacha.create.common.dto.order.OrderListDTO;
import com.chacha.create.common.dto.order.OrderSumDTO;
import com.chacha.create.common.enums.order.OrderStatusEnum;


@Mapper
public interface OrderMapper {
	List<OrderDTO> selectAll(Map<String, Object> paramMap);
	List<OrderDTO> selectForRefundAll(String storeUrl);
	List<OrderDTO> selectForOrderStatus(Map<String, Object> paramMap);
	
	List<OrderDTO> selectForPersonalAll(int memberId);
	List<OrderDTO> selectForPersonalRefundAll(int memberId);
	List<OrderDTO> selectForPersonalOrderStatus(Map<String, Object> paramMap);
	
	List<Map<String,Object>> selectByStatus(String  storeUrl);
	List<OrderSumDTO> selectByDayOrderSum(String  storeUrl);
	List<OrderStatusEnum> selectForOrderStatusOnly(String storeUrl);
	
	// 회원별 주문 내역
	List<OrderListDTO> selectOrderListByMemberId(int memberId);

	// 주문ID별 상세 정보
	OrderDetailDTO selectOrderDetailByOrderId(@Param("orderId") int orderId, @Param("memberId") int memberId);

	// 동일한 주문ID 내의 상품 목록
	List<OrderListDTO> selectOrderListByOrderId(@Param("orderId") int orderId, @Param("memberId") int memberId);
	
	// 카드 번호 암호화를 위한 로직
	String selectCardNumByOrderId(int orderId);
	
	// 회원이 가진 주문 상세 ID 반환
	Integer selectForOrderDetailId(@Param("memberId") int memberId, @Param("productId") int productId);
}