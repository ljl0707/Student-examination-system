package com.hxzy.ssm.dao;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.Option;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.bean.User;

public interface IQuesMapper {
	
	public int add(Question question);
	
	public int update(Question question);
	
	public int del(String id);
	
    public int delMore(Map<String,Object> map);
	
	public int count(Map<String,Object> map);
		
	public List<Question> query(Map<String,Object> map);
	
	public Question getObjById(String id);
	
	//插入数据到选项表
	public int saveOption(Option option);
	//删除问题对应的选项
	public int delMoreOption(Map<String,Object> map);

}
