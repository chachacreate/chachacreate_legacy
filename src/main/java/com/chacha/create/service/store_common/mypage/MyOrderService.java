package com.chacha.create.service.store_common.mypage;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.order.OrderDetailDTO;
import com.chacha.create.common.dto.order.OrderListDTO;
import com.chacha.create.common.dto.order.OrderRequestDTO;
import com.chacha.create.common.entity.member.AddrEntity;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.DeliveryEntity;
import com.chacha.create.common.entity.order.OrderDetailEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.member.AddrMapper;
import com.chacha.create.common.mapper.order.DeliveryMapper;
import com.chacha.create.common.mapper.order.OrderDetailMapper;
import com.chacha.create.common.mapper.order.OrderInfoMapper;
import com.chacha.create.common.mapper.order.OrderMapper;
import com.chacha.create.util.ServiceUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MyOrderService {
	
    private final OrderMapper orderMapper;
    private final AddrMapper addrMapper;
    private final OrderInfoMapper orderInfoMapper;
    private final OrderDetailMapper orderDetailMapper;
	private final DeliveryMapper deliveryMapper;
	
	
	public Integer selectForOrderDetailId(int memberId, int productId) {
        return orderMapper.selectForOrderDetailId(memberId, productId);
    }

	@Transactional(rollbackFor = Exception.class)
    public int placeOrder(OrderRequestDTO request, MemberEntity member) {
    	if(member == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	OrderInfoEntity order = request.getOrderInfo();
        List<OrderDetailEntity> detailList = request.getDetailList();
        AddrEntity addr = request.getAddr();
        boolean isNewAddr = request.isNewAddr();

        order.setMemberId(member.getMemberId());
        order.setOrderDate(new java.sql.Date(System.currentTimeMillis()));
        
        // 주소 입력
        if (isNewAddr) {
        	// isNewAddr = true일 경우 새 주소 입력
            addr.setMemberId(member.getMemberId());
            addrMapper.insert(addr);
            order.setAddressId(addr.getAddressId());
        } else {
        	// 프론트에서 기본 주소의 주소ID를 넘겨줄 경우
        	order.setAddressId(addr.getAddressId());
        }

        orderInfoMapper.insert(order);

        for (OrderDetailEntity detail : detailList) {
            detail.setOrderId(order.getOrderId());
            orderDetailMapper.insert(detail);
        }
        
        // 주문 직후 배송 테이블로 데이터 넘겨주기
        DeliveryEntity delivery = new DeliveryEntity();
        delivery.setOrderId(order.getOrderId());
        delivery.setDeliveryCheck(0);

        deliveryMapper.insert(delivery);

        return order.getOrderId();
    }
    public List<OrderListDTO> getOrderList(int memberId) {
        List<OrderListDTO> orderlist = orderMapper.selectOrderListByMemberId(memberId);
        check_deliveryStatus(orderlist);
        return orderlist;
    }
    
    public AddrEntity baseAddr(MemberEntity member) {
    	return addrMapper.selectForBaseAddr(member.getMemberId());
    }
    
    public int updateBaseAddr(AddrEntity newAddr) {
    	return addrMapper.update(newAddr);
    }
    
    @Transactional(rollbackFor = Exception.class)
    public OrderDetailDTO selectByOrderId(int orderId, MemberEntity member) {
    	if(member == null) {
    		throw new NeedLoginException("로그인이 필요합니다.");
    	}
    	int memberId = member.getMemberId();
        // 주문 상세 조회
        OrderDetailDTO dto = orderMapper.selectOrderDetailByOrderId(orderId, memberId);

		// 주문 상세 내 상품 목록 조회
		List<OrderListDTO> orderlist = orderMapper.selectOrderListByOrderId(orderId, memberId);
		dto.setOrderItems(orderlist);

		// 배송 상태 체크
		check_deliveryStatus(orderlist);

        // 총 금액 계산 (상품 가격 총합)
		int total = 0;
		for (OrderListDTO item : orderlist) {
		    total += item.getOrderPrice();
		}
		dto.setTotalAmount(total);
		
		String cardNum = orderMapper.selectCardNumByOrderId(orderId);
	    dto.setMaskedCardNum(ServiceUtil.maskCardNumber(cardNum));

		dto.setCanCancel(isCancelable(dto.getOrderStatus()));
		dto.setCanRefund(isRefundable(dto.getOrderStatus()));
		dto.setCanWriteReview(canWriteReview(dto.getOrderStatus()));

        return dto;
    }

    // ORDER_OK일 때만 true 반환(취소 가능)
    private boolean isCancelable(OrderStatusEnum status) {
        return status == OrderStatusEnum.ORDER_OK;
    }

    // ORDER_OK일 때만 true 반환(환불 가능)
    private boolean isRefundable(OrderStatusEnum status) {
        return status == OrderStatusEnum.ORDER_OK;
    }

    // ORDER_OK거나 CONFIRM일 경우에만 true 반환(리뷰 작성 가능)
    private boolean canWriteReview(OrderStatusEnum status) {
        return status == OrderStatusEnum.ORDER_OK || status == OrderStatusEnum.CONFIRM;
    }
    
    // 배송 상태 체크
    private void check_deliveryStatus(List<OrderListDTO> orderlist) {
		for (OrderListDTO dto : orderlist) {
			Integer check = dto.getDeliveryCheck();

			switch (check) {
			case 0:
				dto.setDeliveryStatus("배송 전");
				break;
			case 1:
				dto.setDeliveryStatus("배송 중");
				break;
			case 2:
				dto.setDeliveryStatus("배송 완료");
				break;
			default:
				dto.setDeliveryStatus("정보 없음");
			}
		}
    }
}