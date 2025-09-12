package com.chacha.create.service.mainhome.personal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chacha.create.common.dto.boot.BootAddressDTO;
import com.chacha.create.common.dto.order.OrderDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.entity.order.OrderInfoEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;
import com.chacha.create.common.exception.NeedLoginException;
import com.chacha.create.common.mapper.order.OrderInfoMapper;
import com.chacha.create.common.mapper.order.OrderMapper;
import com.chacha.create.util.BootAPIUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class OrderManageService {

    private final OrderMapper orderMapper;
    private final OrderInfoMapper orderInfoMapper;

    // Boot API 호출 유틸
    private final BootAPIUtil bootAPIUtil;

    @Transactional(readOnly = true)
    public List<OrderDTO> selectOrderAll(MemberEntity memberEntity) {
        if (memberEntity == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        List<OrderDTO> orders = orderMapper.selectForPersonalAll(memberEntity.getMemberId());
        fillAddressFromBoot(orders);
        return orders;
    }

    @Transactional(readOnly = true)
    public List<OrderDTO> selectRefundAll(MemberEntity memberEntity) {
        if (memberEntity == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        List<OrderDTO> refunds = orderMapper.selectForPersonalRefundAll(memberEntity.getMemberId());
        fillAddressFromBoot(refunds);
        return refunds;
    }

    @Transactional(readOnly = true)
    public List<OrderDTO> selectForOrderStatus(MemberEntity memberEntity, OrderStatusEnum orderStatus) {
        if (memberEntity == null) {
            throw new NeedLoginException("로그인이 필요합니다.");
        }
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("memberId", memberEntity.getMemberId());
        paramMap.put("orderStatus", orderStatus);

        List<OrderDTO> filtered = orderMapper.selectForPersonalOrderStatus(paramMap);
        fillAddressFromBoot(filtered);
        return filtered;
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateForOrderStatus(int orderId, OrderStatusEnum toStatus) {
        OrderInfoEntity e = new OrderInfoEntity();
        e.setOrderId(orderId);
        e.setOrderStatus(toStatus);
        return orderInfoMapper.updateForOrderStatus(e);
    }

    /**
     * Boot API로 주소 보강 (중복 addressId는 캐시)
     */
    private void fillAddressFromBoot(List<OrderDTO> orders) {
        if (orders == null || orders.isEmpty()) return;

        Map<Integer, BootAddressDTO> cache = new HashMap<>();

        for (OrderDTO dto : orders) {
            try {
                int addressId = dto.getAddressId();
                if (addressId <= 0) continue;

                BootAddressDTO addr = cache.computeIfAbsent(addressId, id -> {
                    try {
                        return bootAPIUtil.getBootMemberAddressDataByAddressId(id);
                    } catch (Exception e) {
                        log.warn("Boot 주소 조회 실패 addressId={}: {}", id, e.getMessage());
                        return null;
                    }
                });

                if (addr != null) {
                    dto.setPostNum(addr.getPostNum());
                    dto.setAddressRoad(addr.getAddressRoad());
                    dto.setAddressDetail(addr.getAddressDetail());
                    dto.setAddressExtra(addr.getAddressExtra());

                    // 프론트에서 전체 주소 문자열을 쓰는 경우 대비
                    String extra = addr.getAddressExtra() == null ? "" : addr.getAddressExtra();
                    String detail = addr.getAddressDetail() == null ? "" : addr.getAddressDetail();
                    String road = addr.getAddressRoad() == null ? "" : addr.getAddressRoad();
                    dto.setAddressFull((road + " " + detail + " " + extra).trim());
                }
            } catch (Exception e) {
                // 주소가 안 채워져도 목록은 나가야 하므로 오류 삼키고 로그만
                log.warn("주소 보강 처리 중 예외 발생 orderId={}: {}", dto.getOrderId(), e.getMessage());
            }
        }
    }
}
