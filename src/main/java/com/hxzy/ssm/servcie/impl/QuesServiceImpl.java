package com.hxzy.ssm.servcie.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Option;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.dao.IQuesMapper;
import com.hxzy.ssm.servcie.IQuesService;
@Service
public class QuesServiceImpl implements IQuesService {

	@Autowired
	private IQuesMapper quesMapper;

	@Override
	@Transactional(isolation=Isolation.READ_COMMITTED,propagation=Propagation.REQUIRED,rollbackFor={Exception.class,RuntimeException.class})
	public int save(Question question) {
		int k=0;
		if(question.getId()>0){
			k=quesMapper.update(question);
		}else{
			//将题目插入到t_question
			k=quesMapper.add(question);
			//将该题目对应的选项插入到选项表 t_option
			//选项一,选项二,选项三,选项四
			String ops=question.getOps();
			String[] options=ops.split(",");
			if(options!=null && options.length>0){
				for(String s:options){
					Option op=new Option();
					op.setOpcontent(s);
					op.setQid(question.getId());
					quesMapper.saveOption(op);
				}
			}
		}
		return k;
	}

	@Override
	public int del(String id) {
		return quesMapper.del(id);
	}

	@Transactional(isolation=Isolation.READ_COMMITTED,propagation=Propagation.REQUIRED,rollbackFor={Exception.class,RuntimeException.class})
	@Override
	public int delMore(Map<String, Object> map) {
		//删除选项表
		quesMapper.delMoreOption(map);
		//int k=1/0;
		return quesMapper.delMore(map);
	}

	@Override
	public int count(Map<String, Object> map) {
		return quesMapper.count(map);
	}

	@Override
	public String query(Map<String, Object> map) {
		String currentpage=(String)map.get("currentpage");
		//设置每页记录数数 
		int pageSize=10;
		//总记录数
		int count=quesMapper.count(map);
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
		
		List<Question> list=quesMapper.query(map);
		
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
	public Question getObjById(String id) {
		return quesMapper.getObjById(id);
	}
	
	

}
