package com.chacha.create.common.mapper.member;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EmailMapper {
	public int updateAuthKey(Map<String, String> map);
	public int insertAuthKey(Map<String, String> map);
	public int checkAuthKey(Map<String, Object> paramMap);
}
