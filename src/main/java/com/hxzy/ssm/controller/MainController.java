package com.hxzy.ssm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Menu;
import com.hxzy.ssm.servcie.IMainService;

@Controller
@RequestMapping("/main")
public class MainController {

	@Autowired
	private IMainService mainService;
	/**
	 * 跳转到main.jsp
	 * @return
	 */
	@RequestMapping("/toMain")
	public String toMain(){
		return "main";
	}
	
	@RequestMapping(value="/getMenu",produces={"application/json;charset=UTF-8"})
	@ResponseBody
	public String getMenu(){
		String json=mainService.getMenuByPid();
		return json;
	}
	
}
