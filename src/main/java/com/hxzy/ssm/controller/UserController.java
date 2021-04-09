package com.hxzy.ssm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.User;
import com.hxzy.ssm.servcie.IUserService;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	private IUserService userService;
	
	/**
	 * 跳转页面
	 * @return
	 */
	@RequestMapping("/touserlist")
    public String userlist(String name){
		return "userlist";
    }
	
	@RequestMapping("/query")
	@ResponseBody
    public String query(HttpServletRequest req){
		Map<String,Object> map=new HashMap<String,Object>();
		//查询条件
		String name=req.getParameter("name");
		String usertype=req.getParameter("usertype");
		//当前第几页
		String currentpage=req.getParameter("currentpage");
		//查询条件
		map.put("name", name);
		map.put("usertype", usertype);
		map.put("currentpage", currentpage);
		String json=userService.query(map);
		return json;
    }
	
	@RequestMapping("/save")
	@ResponseBody
    public String save(User user){
		int k=userService.save(user);
		return String.valueOf(k);
    }
	
	@RequestMapping("/del")
	@ResponseBody
    public String del(String ids){
		//ids   20,209,308
		Map<String,Object> map=new HashMap<String,Object>();
		//map.put("ids", ids);
		map.put("ids", ids.split(","));
		int k=userService.delMore(map);
		return String.valueOf(k);
    }

	@RequestMapping("/getObjById")
	@ResponseBody
	public String getObjById(String id){
		User user=userService.getObjById(id);
		String json=JSON.toJSONString(user);
		return json;
	}
	
}
