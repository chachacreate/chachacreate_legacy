package com.chacha.create.common.mapper.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.chacha.create.common.entity.member.AlterMessageEntity;

@Mapper
public interface AlterMessageMapper {
	List<AlterMessageEntity> selectAll();
	AlterMessageEntity selectByAlterMessageId(int alterMessageId);
	int insert(AlterMessageEntity alterMessageEntity);
	int update(AlterMessageEntity alterMessageEntity);
	int delete(int alterMessageId);
}
