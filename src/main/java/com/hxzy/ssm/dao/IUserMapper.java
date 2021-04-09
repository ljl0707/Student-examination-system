package com.hxzy.ssm.dao;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.User;

public interface IUserMapper {
	
	public int add(User user);
	
	public int update(User user);
	
	public int del(String id);
	
    public int delMore(Map<String,Object> map);
	
	public int count(Map<String,Object> map);
		
	public List<User> query(Map<String,Object> map);
	
	public User getObjById(String id);

}
