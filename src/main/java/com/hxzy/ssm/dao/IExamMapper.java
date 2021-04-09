package com.hxzy.ssm.dao;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.Option;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.bean.Scores;

public interface IExamMapper {
	
	public List<Map<String,Object>> getExams(String userid);
	
	public String getFileById(String pid);
	
	public List<Question> getQues(Map<String,Object> map);
	
	public List<Option> getQptionsByQid(int qid);
	
	public int save(Scores scores);
	
	public int updateStatus();

}
