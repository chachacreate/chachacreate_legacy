package com.chacha.create.common.typehandler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import com.chacha.create.common.enums.order.OrderStatusEnum;

/**
 * MyBatis에서 {@link OrderStatusEnum}와 DB 컬럼(String 코드) 간 변환을 처리하는 TypeHandler 클래스
 */
public class OrderStatusEnumTypeHandler extends BaseTypeHandler<OrderStatusEnum> {

	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, OrderStatusEnum parameter, JdbcType jdbcType) throws SQLException {
	    ps.setString(i, parameter.getCode());  // DB에는 code 저장 ("ORDER_OK" 등)
	}

	@Override
	public OrderStatusEnum getNullableResult(ResultSet rs, String columnName) throws SQLException {
	    String code = rs.getString(columnName);
	    return OrderStatusEnum.from(code);  // code로 enum 변환
	}

	@Override
	public OrderStatusEnum getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
	    String code = rs.getString(columnIndex);
	    return OrderStatusEnum.from(code);
	}

	@Override
	public OrderStatusEnum getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
	    String code = cs.getString(columnIndex);
	    return OrderStatusEnum.from(code);
	}

}
