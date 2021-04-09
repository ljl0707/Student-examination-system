package com.hxzy.ssm.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.servcie.IQuesService;

@Controller
@RequestMapping("/page")
public class QuesController {
	
	@Autowired
	private IQuesService quesService;
	
	/**
	 * 跳转页面
	 * @return
	 */
	@RequestMapping("/toQuestion")
	public String toQuestion(){
		return "queslist";
	}
    /**
     * 跳转到试题编辑页面
     * @return
     */
	@RequestMapping("/toAdd")
	public String toAdd(){
		return "quesEdit";
	}
	
	@RequestMapping(value="/query",produces={"application/json;charset=UTF-8"})
	@ResponseBody
    public String query(HttpServletRequest req){
		Map<String,Object> map=new HashMap<String,Object>();
		//查询条件
		String name=req.getParameter("name");
		String type=req.getParameter("type");
		String course=req.getParameter("course");
		String stage=req.getParameter("stage");
		//当前第几页
		String currentpage=req.getParameter("currentpage");
		//查询条件
		map.put("name", name);
		map.put("type", type);
		map.put("course", course);
		map.put("stage", stage);
		
		map.put("currentpage", currentpage);
		String json=quesService.query(map);
		return json;
    }
	
	@RequestMapping("/save")
	@ResponseBody
    public String save(Question question){
		int k=quesService.save(question);
		return String.valueOf(k);
    }
	
	@RequestMapping("/del")
	@ResponseBody
    public String del(String ids){
		//ids   20,209,308
		Map<String,Object> map=new HashMap<String,Object>();
		//map.put("ids", ids);
		map.put("ids", ids.split(","));
		int k=quesService.delMore(map);
		return String.valueOf(k);
    }

	@RequestMapping("/getObjById")
	@ResponseBody
	public String getObjById(String id){
		Question question=quesService.getObjById(id);
		String json=JSON.toJSONString(question);
		return json;
	}
}
