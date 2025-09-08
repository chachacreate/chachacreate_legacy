package com.chacha.create.common.enums.order;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 주문 상태 열거형 (order_info 테이블의 order_status 컬럼과 매핑)
 * <p>
 * - ORDER_OK: 주문 완료<br>
 * - CONFIRM: 구매 확정<br>
 * - REFUND: 환불 요청<br>
 * - REFUND_OK: 환불 완료
 * </p>
 *
 * <p><b>입력 예시:</b>
 * <pre>{@code
 * "ORDER_OK"
 * "주문 완료"
 * { "code": "ORDER_OK", "name": "주문 완료" }
 * }</pre>
 * </p>
 *
 * <p><b>출력 예시:</b>
 * <pre>{@code
 * "주문 완료"
 * }</pre>
 * </p>
 */
@Getter
@AllArgsConstructor
public enum OrderStatusEnum {

    ORDER_OK("ORDER_OK", "주문완료"),
    SHIPPED("SHIPPED", "발송완료"),
    DELIVERED("DELIVERED", "배송완료"),
    CANCEL_RQ("CANCEL_RQ", "취소요청"),
    CANCEL_OK("CANCEL_OK", "취소완료"),
    REFUND_RQ("REFUND_RQ", "환불요청"),
    REFUND_OK("REFUND_OK", "환불완료");

    private final String code;   // DB에 저장하는 값
    @JsonValue
    private final String name;   // JSON 직렬화 시 보여줄 값

    @JsonCreator
    public static OrderStatusEnum from(Object value) {
        if (value instanceof String) {
            String val = (String) value;
            // code 기준 찾기 (DB 저장/조회용)
            for (OrderStatusEnum status : values()) {
                if (status.code.equalsIgnoreCase(val)) {
                    return status;
                }
            }
            // 혹시 name으로도 찾고 싶으면 여기 추가 가능
            for (OrderStatusEnum status : values()) {
                if (status.name.equalsIgnoreCase(val)) {
                    return status;
                }
            }
        } else if (value instanceof Map) {
            Object codeObj = ((Map<?, ?>) value).get("code");
            if (codeObj instanceof String) {
                String code = (String) codeObj;
                for (OrderStatusEnum status : values()) {
                    if (status.code.equalsIgnoreCase(code)) {
                        return status;
                    }
                }
            }
        }
        throw new IllegalArgumentException("Invalid order status value: " + value);
    }
    
    /**
     * DB에 저장할 code 값을 반환합니다.
     */
    public String getCode() {
        return code;
    }
}

