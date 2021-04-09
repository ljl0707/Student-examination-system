package com.hxzy.ssm.servcie;

import java.util.Map;

import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.bean.User;

public interface IQuesService {
	
	public int save(Question question);
	
	public int del(String id);
	
	public int delMore(Map<String,Object> map);
	
	public int count(Map<String,Object> map);
		
	public String query(Map<String,Object> map);
	
	public Question getObjById(String id);

}
