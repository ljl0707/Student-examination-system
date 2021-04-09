package com.hxzy.ssm.servcie;

import java.util.List;
import java.util.Map;

import com.hxzy.ssm.bean.User;

public interface ILoginService {
	
	public User login(String name,String pwd);

}
