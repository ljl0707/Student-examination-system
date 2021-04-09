package com.hxzy.ssm.dao;

import java.util.List;

import com.hxzy.ssm.bean.Menu;

public interface IMainMapper {
	
	public List<Menu> getMenuByPid(String pid);

}
