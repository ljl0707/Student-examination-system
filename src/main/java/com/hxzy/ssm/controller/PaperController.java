package com.hxzy.ssm.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.sql.TIMESTAMP;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.hxzy.ssm.bean.Paper;
import com.hxzy.ssm.bean.Question;
import com.hxzy.ssm.servcie.IPaperService;

@Controller
@RequestMapping("/paper")
public class PaperController {
	
	@Autowired
	private IPaperService paperService;
	
	/**
	 * 跳转组卷页面
	 * @return
	 */
	@RequestMapping("/toPaper")
    public String Paperlist(String name){
		return "paper";
    }
	
	/**
	 * 跳转试卷管理页面
	 * @return
	 */
	@RequestMapping("/toPaperManager")
    public String toPaperManager(String name){
		return "paperlist";
    }
	
	@RequestMapping(value="/creatPaper",produces={"application/json;charset=UTF-8"})
	@ResponseBody
	public String creatPaper(HttpServletRequest req){
		//单选题数数量
		String singlnum=req.getParameter("singlnum");
		//多选题数量
		String morenum=req.getParameter("morenum");
		//判断题数量
		String judgenum=req.getParameter("judgenum");
		//阶段
		String stage=req.getParameter("stage");
		//专业
		String course=req.getParameter("course");
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("singlnum", singlnum);
		map.put("morenum", morenum);
		map.put("judgenum", judgenum);
		map.put("stage", stage);
		map.put("course", course);
		List<Question> list=paperService.creatPaper(map);
		String json=JSON.toJSONString(list);
		return json;
	}
	
	@RequestMapping(value="/query",produces={"application/json;charset=UTF-8"})
	@ResponseBody
    public String query(HttpServletRequest req){
		Map<String,Object> map=new HashMap<String,Object>();
		//查询条件
		String name=req.getParameter("name");
		String stime=req.getParameter("stime");
		String etime=req.getParameter("etime");
		String isvalid=req.getParameter("isvalid");
		//当前第几页
		String currentpage=req.getParameter("currentpage");
		//查询条件
		map.put("name", name);
		map.put("stime", stime);
		map.put("etime", etime);
		map.put("isvalid", isvalid);
		//分页条件
		map.put("currentpage", currentpage);
		String json=paperService.query(map);
		return json;
    }
	
	@RequestMapping("/save")
	@ResponseBody
    public String save(HttpServletRequest req,MultipartFile uploadfile){
		//文件上传
		String filePath="E:\\upload\\";
		File file=new File(filePath);
		if(!file.exists()){
			file.mkdir();
		}
		Timestamp statime=null;
		Paper paper=new Paper();
		try {
			String filename=uploadfile.getOriginalFilename();
			if(StringUtils.isNotEmpty(filename)){
				uploadfile.transferTo(new File(file,filename));
			}
			//保存数据到数据库表
			String pname=req.getParameter("pname");//试卷名称
			String ptimes=req.getParameter("ptimes");//考试时长
			String starttime=req.getParameter("starttime");//考试开始时间
			String qids=req.getParameter("qids");//问题IDS
			String status=req.getParameter("status");//是否有效
			String pid=req.getParameter("pid");
			paper.setPname(pname);
			paper.setPtimes(Integer.parseInt(ptimes));
			paper.setQids(qids);
			if(StringUtils.isNotEmpty(filename)){
				paper.setUrl(filePath+filename);
			}
			paper.setStatus(status);
			paper.setPid(pid==null?0:Integer.parseInt(pid));
			SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd HH:mm");
			statime = new Timestamp(df.parse(starttime).getTime());
			paper.setStatime(statime);
		} catch (Exception e) {
			e.printStackTrace();
		}
		int k=paperService.save(paper);
		return String.valueOf(k);
    }
	
	@RequestMapping("/del")
	@ResponseBody
    public String del(String ids){
		//ids   20,209,308
		Map<String,Object> map=new HashMap<String,Object>();
		//map.put("ids", ids);
		map.put("ids", ids.split(","));
		int k=paperService.delMore(map);
		return String.valueOf(k);
    }

	@RequestMapping(value="/getObjById",produces={"application/json;charset=UTF-8"})
	@ResponseBody
	public String getObjById(String id){
		Paper paper=paperService.getObjById(id);
		String json=JSON.toJSONStringWithDateFormat(paper, "yyyy/MM/dd HH:mm");
		return json;
	}
	
	/**
	 * 文件下载
	 * @param filename
	 * @param response
	 */
	@RequestMapping("/down")
	public void down(String filename,HttpServletResponse response){
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
}
