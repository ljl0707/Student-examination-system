package com.hxzy.ssm.servcie.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Option;
import com.hxzy.ssm.bean.Paper;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.dao.IPaperMapper;
import com.hxzy.ssm.servcie.IPaperService;
@Service
public class PaperServiceImpl implements IPaperService {

	@Autowired
	private IPaperMapper paperMapper;

	@Override
	public int save(Paper paper) {
		int k=0;
		if(paper.getPid()>0){
			//修改
			k=paperMapper.update(paper);
		}else{
			//增加
			paper.setStatus("1");
			k=paperMapper.add(paper);
		}
		return k;
	}

	@Override
	public int del(String id) {
		return paperMapper.del(id);
	}

	@Override
	public int delMore(Map<String, Object> map) {
		return paperMapper.delMore(map);
	}

	@Override
	public int count(Map<String, Object> map) {
		return paperMapper.count(map);
	}

	@Override
	public String query(Map<String, Object> map) {
		String currentpage=(String)map.get("currentpage");
		//设置每页记录数数 
		int pageSize=10;
		//总记录数
		int count=paperMapper.count(map);
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
		
		List<Paper> list=paperMapper.query(map);
		
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
		String json=JSON.toJSONStringWithDateFormat(resMap, "yyyy-MM-dd HH:mm");
		return json;
	}

	@Override
	public Paper getObjById(String id) {
		return paperMapper.getObjById(id);
	}

	@Override
	public List<Question> creatPaper(Map<String, Object> map) {
		//单选数量
		String singlnum=map.get("singlnum")==null?"20":(String)map.get("singlnum");
		int snum=Integer.parseInt(singlnum);
		if(snum>20 || snum<0){
			snum=20;
		}
		//多选题数量
		String morenum=map.get("morenum")==null?"10":(String)map.get("morenum");
		int mnum=Integer.parseInt(morenum);
		if(mnum>10 || mnum<0){
			mnum=10;
		}
		//判断题数量
		String judgenum=map.get("judgenum")==null?"5":(String)map.get("judgenum");
		int jnum=Integer.parseInt(judgenum);
		if(jnum>5 || jnum<0){
			jnum=5;
		}
		map.put("singlnum", snum);
		map.put("morenum", mnum);
		map.put("judgenum", jnum);
		
		//题目集合
		List<Question> list=paperMapper.creatPaper(map);
		for(Question q:list){
			//通过题目ID，查询选项
			List<Option> options=paperMapper.getOptionsByQid(q.getId());
			q.setOptions(options);
		}
		return list;
	}
	
	

}
