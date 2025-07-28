package com.chacha.create.service.seller.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.mapper.order.OrderInfoMapper;
import com.chacha.create.common.mapper.order.OrderMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class OrderManagementService {

	private final OrderMapper orderMapper;
	private final OrderInfoMapper orderInfoMapper;

	
	public List<OrderDTO> selectOrderAll(String storeUrl) {
		return orderMapper.selectAll(storeUrl);
	}
	
	public List<OrderDTO> selectRefundAll(String storeUrl){
		return orderMapper.selectForRefundAll(storeUrl);
	}
	
	public List<OrderDTO> selectForOrderStatus(String storeUrl, OrderStatusEnum orderStatus){
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("storeUrl", storeUrl);
		paramMap.put("orderStatus", orderStatus);
		return orderMapper.selectForOrderStatus(paramMap);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int updateForRefundStatus(OrderInfoEntity orderInfoEntity) {
		orderInfoEntity.setOrderStatus(OrderStatusEnum.REFUND_OK);
		return orderInfoMapper.updateForOrderStatus(orderInfoEntity);
	}
	
}
