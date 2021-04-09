package com.hxzy.ssm.servcie;

import com.hxzy.ssm.bean.Scores;

public interface IExamService {

	public String getExams(String userid);
	
	public String getFileById(String pid);
	
	public String getQues(String qids);
	
	public int save(Scores scores);
}
