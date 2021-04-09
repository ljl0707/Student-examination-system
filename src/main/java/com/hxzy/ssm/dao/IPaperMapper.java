package com.hxzy.ssm.dao;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.Option;
import com.hxzy.ssm.bean.Paper;
import com.hxzy.ssm.bean.Question;

public interface IPaperMapper {
	
	public int add(Paper paper);
	
	public int update(Paper paper);
	
	public int del(String id);
	
    public int delMore(Map<String,Object> map);
	
	public int count(Map<String,Object> map);
		
	public List<Paper> query(Map<String,Object> map);
	
	public Paper getObjById(String id);
	
	//生成试卷
    public List<Question> creatPaper(Map<String,Object> map);
    
    //根据题目id，查询选项
    public List<Option> getOptionsByQid(int qid);

}
