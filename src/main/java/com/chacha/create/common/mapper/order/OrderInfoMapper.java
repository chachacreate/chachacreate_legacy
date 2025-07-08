package com.chacha.create.common.mapper.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.order.OrderInfoEntity;

/**
 * {@code order_info} 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface OrderInfoMapper {

    /**
     * 모든 주문 정보를 조회합니다.
     *
     * @return {@code OrderInfoEntity} 리스트
     */
    List<OrderInfoEntity> selectAll();

    /**
     * 주어진 주문 ID에 해당하는 주문 정보를 조회합니다.
     *
     * @param orderId 조회할 주문 ID
     * @return 해당 주문 ID에 대한 {@code OrderInfoEntity} 객체 (없으면 null)
     */
    OrderInfoEntity selectByOrderId(int orderId);

    /**
     * 주어진 회원 ID에 해당하는 주문 정보를 조회합니다.
     *
     * @param memberId 회원 ID
     * @return 해당 회원이 한 주문 목록 ({@code OrderInfoEntity} 리스트)
     */
    List<OrderInfoEntity> selectByMemberId(int memberId);

    /**
     * 새로운 주문 정보를 추가합니다.
     * {@code order_id}는 {@code seq_order_info_id.NEXTVAL} 시퀀스를 통해 자동 생성됩니다.
     *
     * @param orderInfo 삽입할 {@code OrderInfoEntity} 객체
     * @return 영향 받은 행 수
     */
    int insert(OrderInfoEntity orderInfo);

    /**
     * 기존 주문 정보를 수정합니다.
     *
     * @param orderInfo 수정할 {@code OrderInfoEntity} 객체
     * @return 영향 받은 행 수
     */
    int update(OrderInfoEntity orderInfo);
    
    /**
     * 기존 주문 정보 중 OrderStatus만 수정합니다.
     *
     * @param orderInfo 수정할 {@code OrderInfoEntity} 객체
     * @return 영향 받은 행 수
     */
    int updateForOrderStatus(OrderInfoEntity orderInfo);

    /**
     * 주어진 주문 ID에 해당하는 주문 정보를 삭제합니다.
     *
     * @param orderId 삭제할 주문 ID
     * @return 영향 받은 행 수
     */
    int delete(int orderId);
}
