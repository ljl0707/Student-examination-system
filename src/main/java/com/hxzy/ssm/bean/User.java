package com.hxzy.ssm.bean;

import java.io.Serializable;

/**
 * 徐伟
 * @author 888
 *
 */
public class User implements Serializable{
	
	private static final long serialVersionUID = 6387731838641568293L;
	//实例变量
	private String id;
	private String username; //用户名
	private int usertype; //用户类型   0  管理员(教师) 1 学生
	private String pwd;
	private int age;
	private String sex;
	private String tel;
	
	public User() {
		
	}
	
	public User(String id, String username, int usertype, String pwd, int age,
			String sex, String tel) {
		this.id = id;
		this.username = username;
		this.usertype = usertype;
		this.pwd = pwd;
		this.age = age;
		this.sex = sex;
		this.tel = tel;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public int getUsertype() {
		return usertype;
	}

	public void setUsertype(int usertype) {
		this.usertype = usertype;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", username=" + username + ", usertype="
				+ usertype + ", pwd=" + pwd + ", age=" + age + ", sex=" + sex
				+ ", tel=" + tel + "]";
	}
}
	
