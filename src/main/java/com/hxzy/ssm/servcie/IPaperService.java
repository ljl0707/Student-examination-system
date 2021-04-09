package com.hxzy.ssm.servcie;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.Paper;
import com.hxzy.ssm.bean.Question;

public interface IPaperService {
	
	public int save(Paper paper);
	
	public int del(String id);
	
	public int delMore(Map<String,Object> map);
	
	public int count(Map<String,Object> map);
		
	public String query(Map<String,Object> map);
	
	public Paper getObjById(String id);
	//生成试卷
	public List<Question> creatPaper(Map<String,Object> map);

}
