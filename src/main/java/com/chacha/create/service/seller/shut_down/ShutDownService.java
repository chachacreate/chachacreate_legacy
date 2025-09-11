package com.chacha.create.service.seller.shut_down;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.boot.BootTokenDTO;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.mapper.order.OrderMapper;
import com.chacha.create.common.mapper.store.StoreMapper;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ShutDownService {

	private final StoreMapper storeMapper;
	private final OrderMapper orderMapper;
	private final BootAPIUtil bootAPIUtil;
	
	@Transactional(rollbackFor = Exception.class)
	public String shutdown(Integer memberId, String storeUrl, HttpServletResponse response) {
		StoreEntity thisStore = storeMapper.selectByStoreUrl(storeUrl);
		StoreEntity storeEntity = StoreEntity.builder()
			.storeId(thisStore.getStoreId())
			.sellerId(thisStore.getSellerId())
			.logoImg(null)
			.storeName(null)
			.storeDetail(null)
			.storeUrl(null)
			.saleCnt(null)
			.viewCnt(null)
			.build();
		
		BootTokenDTO tokenDTO = bootAPIUtil.downgradeMemberToUser(memberId, response);

		List<OrderStatusEnum> orderStatuses = orderMapper.selectForOrderStatusOnly(storeUrl);

		boolean hasOrderOk = orderStatuses.stream()
			.anyMatch(status -> status == OrderStatusEnum.ORDER_OK);

		if (hasOrderOk) {
			throw new IllegalStateException("모든 주문이 처리 완료가 되지않아 폐점할 수 없습니다.");
		}

		// Store 비우기
		storeMapper.update(storeEntity);

		// Seller 테이블의 personal_check = 1 설정
		storeMapper.updatePersonalCheck(thisStore.getSellerId());

		return tokenDTO.getAccessToken();
	}
}
