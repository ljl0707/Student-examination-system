package com.hxzy.ssm.servcie.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hxzy.ssm.bean.User;
import com.hxzy.ssm.dao.ILoginMapper;
import com.hxzy.ssm.servcie.ILoginService;
@Service
public class LoginServiceImpl implements ILoginService{
    
	@Autowired
	private ILoginMapper loginMapper;
	
	@Override
	public User login(String name, String pwd) {
		return loginMapper.login(name, pwd);
	}

}
