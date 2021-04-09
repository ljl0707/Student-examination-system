package com.hxzy.ssm.servcie.impl;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.exceptions.JedisConnectionException;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Menu;
import com.hxzy.ssm.dao.IMainMapper;
import com.hxzy.ssm.servcie.IMainService;
import com.hxzy.ssm.util.RedisUtil;

@Service
public class MainServiceImpl implements IMainService{

	@Autowired
	private IMainMapper mainMapper;
	
	private Jedis jedis=null;
	
	@Override
	public String getMenuByPid() {
		String menues="";
		try {
			jedis=RedisUtil.getJedis();
		}  catch (Exception e) {
			e.printStackTrace();
		}
		if(jedis!=null){
			//1、从redis中取菜单信息
			menues=jedis.get("menujson");
			if(StringUtils.isEmpty(menues)){
				menues=getMenuByRDB();
				//将关系型数据中的信息到放到redis 中
				jedis.set("menujson", menues);
				//设置menujson 过期时间,单位是秒
				jedis.expire("menujson", 7*24*60*60);
			}
		}else{
			menues=getMenuByRDB();
		}
		return menues;
	}

	private String  getMenuByRDB(){
		//查询一级菜单
		List<Menu> list=mainMapper.getMenuByPid("0");
		for(Menu menu:list){
			//查询二级菜单
			List<Menu> children= mainMapper.getMenuByPid(menu.getId());
			menu.setChildren(children);
		}
		String json=JSON.toJSONString(list);
		return json;
	}
}
