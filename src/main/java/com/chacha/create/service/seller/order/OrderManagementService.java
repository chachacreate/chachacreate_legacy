package com.chacha.create.service.seller.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.boot.BootAddressDTO;
import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.mapper.order.OrderInfoMapper;
import com.chacha.create.common.mapper.order.OrderMapper;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class OrderManagementService {

	private final OrderMapper orderMapper;
	private final OrderInfoMapper orderInfoMapper;
	private final BootAPIUtil bootAPIUtil;

	
	public List<OrderDTO> selectOrderAll(String storeUrl) {
	    List<OrderDTO> orders = orderMapper.selectAll(storeUrl);

	    for (OrderDTO dto : orders) {
	        int addressId = dto.getAddressId();
	        BootAddressDTO addr = bootAPIUtil.getBootMemberAddressDataByAddressId(addressId);
	        if (addr != null) {
	            dto.setPostNum(addr.getPostNum());
	            dto.setAddressRoad(addr.getAddressRoad());
	            dto.setAddressDetail(addr.getAddressDetail());
	            dto.setAddressExtra(addr.getAddressExtra());
	        }
	    }

	    return orders;
	}
	
	public List<OrderDTO> selectRefundAll(String storeUrl){
		return orderMapper.selectForRefundAll(storeUrl);
	}
	
	public List<OrderDTO> selectForOrderStatus(String storeUrl, OrderStatusEnum orderStatus){
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("storeUrl", storeUrl);
	    paramMap.put("orderStatus", orderStatus);

	    // 1️. DB에서 주문/상품/카드 데이터만 가져오기
	    List<OrderDTO> orders = orderMapper.selectForOrderStatus(paramMap);

	    // 2️. 각 주문 DTO에 bootAPI 주소 채우기
	    for (OrderDTO dto : orders) {
	        int addressId = dto.getAddressId();
	        BootAddressDTO addr = bootAPIUtil.getBootMemberAddressDataByAddressId(addressId);

	        if (addr != null) {
	            dto.setPostNum(addr.getPostNum());
	            dto.setAddressRoad(addr.getAddressRoad());
	            dto.setAddressDetail(addr.getAddressDetail());
	            dto.setAddressExtra(addr.getAddressExtra());
	        }
	    }

	    return orders;
	}
	
	public boolean updateOrderStatus(int orderId, OrderStatusEnum toStatus) {
        OrderInfoEntity entity = new OrderInfoEntity();
        entity.setOrderId(orderId);
        entity.setOrderStatus(toStatus);
        int affected = orderInfoMapper.updateForOrderStatus(entity);
        return affected > 0;
    }
	
	@Transactional(rollbackFor = Exception.class)
	public int updateForRefundStatus(OrderInfoEntity orderInfoEntity) {
		orderInfoEntity.setOrderStatus(OrderStatusEnum.REFUND_OK);
		return orderInfoMapper.updateForOrderStatus(orderInfoEntity);
	}
	
}
