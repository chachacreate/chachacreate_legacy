package com.chacha.create.common.typehandler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import com.chacha.create.common.enums.category.TypeCategoryEnum;

/**
 * MyBatis에서 {@link TypeCategoryEnum}과 DB의 정수 ID 간 매핑을 처리하는 TypeHandler입니다.
 * <p>
 * Enum 값을 DB에 저장할 때는 해당 Enum의 ID(int)로 변환하여 저장하고,
 * DB에서 값을 읽어올 때는 ID를 기반으로 Enum으로 변환합니다.
 * </p>
 */
public class TypeCategoryEnumTypeHandler extends BaseTypeHandler<TypeCategoryEnum> {

    /**
     * PreparedStatement에 Enum의 ID 값을 설정합니다.
     *
     * @param ps        PreparedStatement 객체
     * @param i         파라미터 인덱스 (1부터 시작)
     * @param parameter 변환할 {@link TypeCategoryEnum} Enum 값
     * @param jdbcType  JDBC 타입 (사용 안 할 수도 있음)
     * @throws SQLException DB 처리 중 예외 발생 시 던져짐
     */
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, TypeCategoryEnum parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getId()); // Enum → DB int 값 변환
    }

    /**
     * ResultSet에서 컬럼명으로 정수 값을 조회하여 Enum으로 변환합니다.
     *
     * @param rs         ResultSet 객체
     * @param columnName 컬럼명
     * @return DB 정수 ID에 해당하는 {@link TypeCategoryEnum}
     * @throws SQLException DB 조회 중 예외 발생 시 던져짐
     */
    @Override
    public TypeCategoryEnum getNullableResult(ResultSet rs, String columnName) throws SQLException {
        int id = rs.getInt(columnName);
        return TypeCategoryEnum.fromId(id); // DB int → Enum 변환
    }

    /**
     * ResultSet에서 컬럼 인덱스로 정수 값을 조회하여 Enum으로 변환합니다.
     *
     * @param rs          ResultSet 객체
     * @param columnIndex 컬럼 인덱스 (1부터 시작)
     * @return DB 정수 ID에 해당하는 {@link TypeCategoryEnum}
     * @throws SQLException DB 조회 중 예외 발생 시 던져짐
     */
    @Override
    public TypeCategoryEnum getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        int id = rs.getInt(columnIndex);
        return TypeCategoryEnum.fromId(id);
    }

    /**
     * CallableStatement에서 컬럼 인덱스로 정수 값을 조회하여 Enum으로 변환합니다.
     * (주로 프로시저 호출 결과 처리 시 사용)
     *
     * @param cs          CallableStatement 객체
     * @param columnIndex 컬럼 인덱스 (1부터 시작)
     * @return DB 정수 ID에 해당하는 {@link TypeCategoryEnum}
     * @throws SQLException DB 조회 중 예외 발생 시 던져짐
     */
    @Override
    public TypeCategoryEnum getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        int id = cs.getInt(columnIndex);
        return TypeCategoryEnum.fromId(id);
    }
}
