package com.hxzy.ssm.dao;

import org.apache.ibatis.annotations.Param;

import com.hxzy.ssm.bean.User;

public interface ILoginMapper {

	public User login(@Param("name") String a,@Param("pwd") String b);
}
