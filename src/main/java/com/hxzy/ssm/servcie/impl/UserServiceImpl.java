package com.hxzy.ssm.servcie.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.User;
import com.hxzy.ssm.dao.IUserMapper;
import com.hxzy.ssm.servcie.IUserService;
@Service
public class UserServiceImpl implements IUserService {

	@Autowired
	private IUserMapper userMapper;

	@Override
	public int save(User user) {
		int k=0;
		if(StringUtils.isNotEmpty(user.getId())){
			k=userMapper.update(user);
		}else{
			k=userMapper.add(user);
		}
		return k;
	}

	@Override
	public int del(String id) {
		return userMapper.del(id);
	}

	@Override
	public int delMore(Map<String, Object> map) {
		return userMapper.delMore(map);
	}

	@Override
	public int count(Map<String, Object> map) {
		return userMapper.count(map);
	}

	@Override
	public String query(Map<String, Object> map) {
		String currentpage=(String)map.get("currentpage");
		//设置每页记录数数 
		int pageSize=10;
		//总记录数
		int count=userMapper.count(map);
		//总页数
		int allpage=count%pageSize==0?count/pageSize:count/pageSize+1;
		
		if(StringUtils.isEmpty(currentpage)){
			currentpage="1";
		}
		int pagenum=Integer.parseInt(currentpage);
		if(pagenum<=1){
			pagenum=1;
		}
		if(allpage>0 && pagenum>=allpage){
			pagenum=allpage;
		}
		//分页条件
		map.put("skipnum", (pagenum-1)*pageSize);
		map.put("pagesize", pageSize);
		
		List<User> list=userMapper.query(map);
		
		//返回结果
		Map<String,Object> resMap=new HashMap<String,Object>();
		//总记录数
		resMap.put("count", count);
		//当前第几页
		resMap.put("currentpage", pagenum);
		//总页数
		resMap.put("allpage", allpage);
		//每页记录数
		resMap.put("pagesize", pageSize);
		//集合
		resMap.put("list", list);
		String json=JSON.toJSONString(resMap);
		return json;
	}

	@Override
	public User getObjById(String id) {
		return userMapper.getObjById(id);
	}
	
	

}
