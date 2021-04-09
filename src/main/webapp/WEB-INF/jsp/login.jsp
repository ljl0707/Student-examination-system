<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<!DOCTYPE html >
<%
String path=request.getContextPath();
String username="";
String pwd="";
//从cookie 中获取用户名与密码
Cookie[] cookies=request.getCookies();
if(cookies!=null && cookies.length>0){
	for(Cookie ck:cookies){
		String ckname=ck.getName();
		if("logincookie".equals(ckname)){
			String ckvalue=ck.getValue();
			//用户名
			username=ckvalue.substring(0,ckvalue.indexOf("_"));
		    pwd=ckvalue.substring(ckvalue.indexOf("_")+1);
		}
	}
}
pageContext.setAttribute("username",username);
pageContext.setAttribute("pwd",pwd);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%=path %>/css/login.css" />
<script type="text/javascript" src="<%=path %>/js/jquery-3.2.1.min.js"></script>
<title>登录</title>

<script type="text/javascript">

</script>
</head>
<body>
   
<div class="main">
    <div class="title">
        <span>登录</span>
    </div>
    <div class="title-msg">
        <span>请输入登录账户和密码</span>
    </div>
 
    <form class="login-form" action="<%=path %>/login/login.do" method="post" novalidate >
        <!--输入框-->
        <div class="input-content">
            <div>
                <input type="text" autocomplete="off"
                       placeholder="用户名" name="username" required value="${username}" />
            </div>
 
            <div style="margin-top: 16px">
                <input type="password"
                       autocomplete="off" placeholder="登录密码" name="pwd" required maxlength="12" value="${pwd}" />
            </div>
        </div>
        <!--登入按钮-->
        <div style="text-align: center">
            <button type="submit" class="enter-btn" >登录</button>
        </div>
 
        <div class="foor">
            <div class="left"><div style="float:left;margin-top:2px;"><input type="checkbox" name="rember"  <c:if test="${ not empty username}"> checked="checked" </c:if> style="padding-top:10px;"/></div> &nbsp;<span>记住我</span></div>
            <div class="right"><span>忘记密码 ?</span></div>
        </div>
      </form>
   </div>
</body>
</html>