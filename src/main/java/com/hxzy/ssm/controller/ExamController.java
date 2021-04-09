package com.hxzy.ssm.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hxzy.ssm.bean.Paper;
import com.hxzy.ssm.bean.Scores;
import com.hxzy.ssm.bean.User;
import com.hxzy.ssm.servcie.IExamService;

@Controller
@RequestMapping("/exam")
public class ExamController {
	
	@Autowired
	private IExamService examService;
	
	@RequestMapping("/examindex")
	public String examindex(){
		return "examindex";
	}

	@RequestMapping(value="/getExams",produces={"application/json;charset=UTF-8"})
	@ResponseBody
	public String getExams(HttpSession session){
		String userid="";
		if(session.getAttribute("userinfo")!=null){
			User user=(User)session.getAttribute("userinfo");
			if(user!=null){
				userid=user.getId();
			}
		}
		String json=examService.getExams(userid);
		return json;
	}
	
	@RequestMapping("/toexam")
	public String toexam(HttpServletRequest req,Model model){
		String pid=req.getParameter("pid");
		String qids=req.getParameter("qids");
		String pname=req.getParameter("pname");
		String ptimes=req.getParameter("ptimes");
		String etime=req.getParameter("endtime");//2021-02-19 18:18
		SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm");
		long endtime=0;
		try {
			Date enddate=df.parse(etime);
			endtime=enddate.getTime();
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("pid", pid);
		model.addAttribute("qids", qids);
		model.addAttribute("pname", pname);
		model.addAttribute("endtime", endtime);
		model.addAttribute("ptimes", ptimes);
		return "exampaper";
	}
	
	@RequestMapping(value="/checkFile",produces={"application/json;charset=UTF-8"})
	@ResponseBody
	public String checkFile(String pid){
		String filepath=examService.getFileById(pid);
		return filepath;
	}
	
	/**
	 * 文件下载
	 * @param filename
	 * @param response
	 */
	@RequestMapping("/downFile")
	public void downFile(String filename,HttpServletResponse response){
		File file=new File("E:\\upload\\",filename);
		if(file== null || !file.exists()){
			return;
		}
		try {
			response.setContentType("application/octet-stream;charset=utf-8");
			response.setHeader("Content-Disposition", "attachment;filename=" + new String(filename.getBytes("gb2312"), "ISO8859-1"));
			ServletOutputStream out = response.getOutputStream();
			out.write(FileUtils.readFileToByteArray(file));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	//通过问题ID，查询理论题
	@RequestMapping(value="/getQues",produces={"application/json;charset=UTF-8"})
	@ResponseBody
	public String getQues(String qids){
		String json=examService.getQues(qids);
		return json;
	}
	
	//提交试卷,保存成绩
	@RequestMapping(value="/save")
	public String save(HttpServletRequest req,HttpSession session){
		
		String pid =req.getParameter("pid");
		String score =req.getParameter("score");
		String myidanswer =req.getParameter("myidanswer");
		String usetime =req.getParameter("usetime");
		User user=null;
		if(session.getAttribute("userinfo")!=null){
			user=(User)session.getAttribute("userinfo");
		}
		Scores scores=new Scores();
		scores.setMyanswer(myidanswer);
		scores.setScores(Double.parseDouble(score));
		scores.setUser(user);
		Paper paper=new Paper(Integer.parseInt(pid));
		scores.setPaper(paper);
		scores.setUsetimes(usetime);
		//保存
		try {
			int k=examService.save(scores);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/exam/examindex.do";
	}
}
