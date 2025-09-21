package com.chacha.create.service.seller.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.boot.BootAddressDTO;
import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.entity.order.OrderDetailEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.mapper.order.OrderDetailMapper;
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
	private final OrderDetailMapper orderDetailMapper;
	private final BootAPIUtil bootAPIUtil;

	
	public List<OrderDTO> selectForOrderStatus(String storeUrl, OrderStatusEnum orderStatus, int offset, int size) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("storeUrl", storeUrl);
	    paramMap.put("orderStatus", orderStatus);
	    paramMap.put("offset", offset);
	    paramMap.put("size", size);

	    List<OrderDTO> orders = orderMapper.selectForOrderStatus(paramMap);
	    fillAddress(orders);
	    return orders;
	}

	public List<OrderDTO> selectOrderAll(String storeUrl, int offset, int size) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("storeUrl", storeUrl);
	    paramMap.put("offset", offset);
	    paramMap.put("size", size);

	    List<OrderDTO> orders = orderMapper.selectAll(paramMap);
	    fillAddress(orders);
	    return orders;
	}

	// 공통 주소 채우기 메서드
	private void fillAddress(List<OrderDTO> orders) {
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
	}

	
	public List<OrderDTO> selectRefundAll(String storeUrl){
		return orderMapper.selectForRefundAll(storeUrl);
	}
	
	// 주문 상태 변경(주문 상세 기준)
	public boolean updateOrderStatus(int orderDetailId, OrderStatusEnum toStatus) {
//        OrderInfoEntity entity = new OrderInfoEntity();
//        entity.setOrderId(orderId);
//        entity.setOrderStatus(toStatus);
        int affected = orderDetailMapper.updateStatus(orderDetailId, toStatus);
        return affected > 0;
    }
	
	@Transactional(rollbackFor = Exception.class)
	public int updateForRefundStatus(OrderInfoEntity orderInfoEntity) {
		orderInfoEntity.setOrderStatus(OrderStatusEnum.REFUND_OK);
		return orderInfoMapper.updateForOrderStatus(orderInfoEntity);
	}
	
}
