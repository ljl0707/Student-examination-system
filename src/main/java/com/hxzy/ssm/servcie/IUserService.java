package com.hxzy.ssm.servcie;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.User;

public interface IUserService {
	
	public int save(User user);
	
	public int del(String id);
	
	public int delMore(Map<String,Object> map);
	
	public int count(Map<String,Object> map);
		
	public String query(Map<String,Object> map);
	
	public User getObjById(String id);

}
