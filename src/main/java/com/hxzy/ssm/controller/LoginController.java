package com.hxzy.ssm.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hxzy.ssm.bean.User;
import com.hxzy.ssm.servcie.ILoginService;

@Controller
@RequestMapping("/login")
public class LoginController {
	
    @Autowired
	private ILoginService loginService;
	
	@RequestMapping("/toLogin")
	public String toLogin(){
		return "login";
	}
	
	@RequestMapping("/login")
	public String login(String username,String pwd,String rember,HttpSession session,HttpServletResponse res){
		User user=loginService.login(username, pwd);
		if("on".equals(rember)){
			//记住用户名与密码
			Cookie cookie=new Cookie("logincookie",username+"_"+pwd);
			//7 天
			cookie.setMaxAge(60*60*24*7);
			//保存位置
			cookie.setPath("/");
			//将cookie信息保存到客户端
			res.addCookie(cookie);
		}else{
			Cookie cookie=new Cookie("logincookie",username+"_"+pwd);
			//0天
			cookie.setMaxAge(0);
			//保存位置
			cookie.setPath("/");
			//将cookie信息保存到客户端
			res.addCookie(cookie);
		}
		String url="";
		if(user!=null && StringUtils.isNotEmpty(user.getId())){
			if(user.getUsertype()==0){
				//管理员
				url="redirect:/main/toMain.do";
			}else if(user.getUsertype()==1){
				//学生
				url="redirect:/exam/examindex.do";
			}
			session.setAttribute("userinfo", user);
		}else{
			url="login";
		}
		return url;
	}
	@RequestMapping("/logout")
	public String logout(HttpSession session){
		//session失效
		session.invalidate();
		return "login";
	}
}
