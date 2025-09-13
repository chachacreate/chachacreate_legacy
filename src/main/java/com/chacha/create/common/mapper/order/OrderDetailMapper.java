package com.chacha.create.common.mapper.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.chacha.create.common.entity.order.OrderDetailEntity;
import com.chacha.create.common.enums.order.OrderStatusEnum;

/**
 * order_detail 테이블에 대한 CRUD 작업을 수행하는 MyBatis 매퍼 인터페이스입니다.
 */
@Mapper
public interface OrderDetailMapper {

    /**
     * 모든 주문 상세 정보를 조회합니다.
     *
     * @return 주문 상세 엔티티 리스트
     */
    List<OrderDetailEntity> selectAll();

    /**
     * orderDetailId로 특정 주문 상세 정보를 조회합니다.
     *
     * @param orderDetailId 조회할 주문 상세 ID
     * @return 조회된 OrderDetailEntity 객체 (없으면 null)
     */
    OrderDetailEntity selectByOrderDetailId(int orderDetailId);

    /**
     * orderId로 관련된 모든 주문 상세 정보를 조회합니다.
     *
     * @param orderId 조회할 주문 ID
     * @return 조회된 OrderDetailEntity 리스트
     */
    List<OrderDetailEntity> selectByOrderId(int orderId);

    /**
     * 새로운 주문 상세 정보를 삽입합니다.
     * seq_order_detail_id 시퀀스를 사용하여 order_detail_id가 자동 생성됩니다.
     *
     * @param orderDetail 삽입할 OrderDetailEntity 객체
     * @return 삽입 성공 시 영향 받은 행 수
     */
    int insert(OrderDetailEntity orderDetail);

    /**
     * 기존 주문 상세 정보를 수정합니다.
     *
     * @param orderDetail 수정할 OrderDetailEntity 객체
     * @return 수정 성공 시 영향 받은 행 수
     */
    int update(OrderDetailEntity orderDetail);
    
    // Boot에서 취소/환불 요청 > orderDetail 테이블의 주문 상태 업데이트
    int updateStatus(@Param("orderDetailId") int orderDetailId, @Param("orderStatus") OrderStatusEnum orderStatus);


    /**
     * orderDetailId로 주문 상세 정보를 삭제합니다.
     *
     * @param orderDetailId 삭제할 주문 상세 ID
     * @return 삭제 성공 시 영향 받은 행 수
     */
    int delete(int orderDetailId);
}
