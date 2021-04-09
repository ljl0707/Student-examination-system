package com.hxzy.ssm.servcie.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Option;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.bean.Scores;
import com.hxzy.ssm.dao.IExamMapper;
import com.hxzy.ssm.servcie.IExamService;
@Service
@EnableScheduling
public class ExamServiceImpl implements IExamService{

	@Autowired
	private IExamMapper examMapper;
	
	@Override
	public String getExams(String userid) {
		List<Map<String,Object>> list=examMapper.getExams(userid);
		String json=JSON.toJSONStringWithDateFormat(list, "yyyy-MM-dd HH:mm");
		return json;
	}

	@Override
	public String getFileById(String pid) {
		return examMapper.getFileById(pid);
	}

	@Override
	public String getQues(String qids) {
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("qids", qids);
		List<Question> list=examMapper.getQues(map);
		//通过问题ID，查询选项
		for(Question question:list){
			int qid=question.getId();
			List<Option> options=examMapper.getQptionsByQid(qid);
			question.setOptions(options);
		}
		String json=JSON.toJSONString(list);
		return json;
	}

	@Override
	public int save(Scores scores) {
		return examMapper.save(scores);
	}

	@Scheduled(cron="0 0 0/1 * * ?")
	//@Scheduled(initialDelay=2000,fixedDelay=1000)
	public void test(){
		examMapper.updateStatus();
	}

}
