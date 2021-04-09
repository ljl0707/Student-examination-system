<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String path=request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" href="<%=path %>/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=path%>/css/jquery.datetimepicker.css">
<script type="text/javascript" src="<%=path %>/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="<%=path %>/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/jquery.datetimepicker.full.js"></script>
<script type="text/javascript">
   $(function(){
	   getMenu();
   })
   
   function getMenu(){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/main/getMenu.do",
		   data:{},
		   dataType:"json",
		   success:function(res){
			   //[ {"children":[{"id":"5","name":"用户信息","pid":"4","url":"../user/touserlist.do"}],"id":"4","name":"用户管理","pid":"0"},
			     //{"children":[{"id":"9","name":"查询试卷","pid":"6","url":"../page/toPaperManager.do"},{"id":"8","name":"生成试卷","pid":"6","url":"../page/toPaper.do"},{"id":"7","name":"成绩管理","pid":"6","url":"../page/toGrade_man.do"}],"id":"6","name":"试卷管理","pid":"0"},
			      //{"children":[{"id":"2","name":"新增试题","pid":"1","url":"../page/toAdd.do"},{"id":"3","name":"查询试题","pid":"1","url":"../page/toQuestion.do"}],"id":"1","name":"题库管理","pid":"0"}]
			   var html="";
			   for(var i in res){
				   var obj=res[i];
				   var child="";
				   for(var j in obj.children){
					   var c=obj.children[j];
					   child+="<li><a href="+c.url+">"+c.name+"</a></li>";
				   }
				   html+="<li class='dropdown'>"+
				               "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>"+obj.name+"<b class='caret'></b></a>"+
				               "<ul class='dropdown-menu'>"+child+"</ul>"+
			              "</li>";
			   }
			   $("#ul").html(html);
		   }
	   })
   }
</script>
</head>
<body>
   <!-- 导航菜单 -->
   <nav class="navbar navbar-default" role="navigation">
	    <div class="container-fluid">
		    <div class="navbar-header">
		        <a class="navbar-brand" href="<%=path%>/main/toMain.do">智原在线考试系统</a>
		    </div>
		    <div>
		        <!--向左对齐-->
		        <ul class="nav navbar-nav navbar-left" id="ul">
		            
		        </ul>
		        <ul class="nav navbar-nav navbar-right"> 
		            <li><a href="<%=path%>/login/toLogin.do"><span class="glyphicon glyphicon-user"></span> 登录</a></li> 
		            <li><a href="<%=path%>/login/logout.do"><span class="glyphicon glyphicon-log-in"></span> 退出</a></li> 
	            </ul> 
		    </div>
	    </div>
	</nav>
</body>
</html>