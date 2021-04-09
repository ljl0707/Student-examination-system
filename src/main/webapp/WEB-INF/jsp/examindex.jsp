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
   var username='${userinfo.username}';
   $(function(){
	   getExams();
   })
   
   var json="";
   //定时任务
   setInterval("getInfo(json)", 1000*60);
   
   function getExams(){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/exam/getExams.do",
		   data:{},
		   dataType:"json",
		   success:function(res){
			   //[{"statime":"2021-02-18 11:27","qids":"423,418,453,923","ptimes":1,"pname":"java一阶段考试2","endtime":"2021-02-18 12:27","pid":1,"status":"1"},
			   //{"statime":"2021-02-18 08:40","qids":"418,392,387,453,931,466","ptimes":2,"pname":"222考","endtime":"2021-02-18 10:40","pid":2,"status":"0"},{"statime":"2021-02-03 14:22","ptimes":2,"pname":"22考","endtime":"2021-02-03 16:22","pid":10,"status":"1"},{"statime":"2021-02-02 15:15","qids":"413,387,423,930,392,398,433,428,382,418,408,931,458,453,923,466,463","ptimes":1,"pname":"考试测试","endtime":"2021-02-02 16:15","pid":5,"status":"1"},{"statime":"2021-02-02 15:05","qids":"408,423,453,923,932","ptimes":1,"pname":"4考","endtime":"2021-02-02 16:05","pid":4,"status":"1"},{"statime":"2021-02-02 00:00","qids":"408,423,453,923,932","ptimes":1,"pname":"3考","endtime":"2021-02-02 01:00","pid":3,"status":"1"},{"ptimes":0,"pid":13,"status":"1"}]
			   json=res;
			   getInfo(res);
		   }
	   })
   }
   
   function getInfo(res){
	   var html="";
	   for(var i in res){
		   var curruntDate=new Date();
		   var year=curruntDate.getFullYear();
		   var moth=curruntDate.getMonth()+1;
		   moth=moth<10?"0"+moth:moth;
		   var date=curruntDate.getDate();
		   date=date<10?"0"+date:date;
		   var hour = curruntDate.getHours(); 
		   hour=hour<10?"0"+hour:hour;
		   var minute = curruntDate.getMinutes(); 
		   minute=minute<10?"0"+minute:minute;
		   var sysdate=year+"-"+moth+"-"+date+" "+hour+":"+minute;
		   
    	   var obj=res[i];
    	   var scid=obj.scid==undefined?'':obj.scid;
    	   var pname=obj.pname==undefined?'':obj.pname;
    	   var time=obj.statime+'(时长'+obj.ptimes+'小时)---'+obj.endtime;
    	   var status=obj.status==undefined?'':obj.status;
    	   status=status==0?"<span style='color: red;'>无效</span>":"<span style='color: green;'>有效</span>";
    	   var scores=obj.scores==undefined?'':"<p>考生成绩:<span style='color: red;'>"+obj.scores+"</span></p>";
    	   var button="<a class='btn btn-danger btn-lg' role='button' disabled='disabled'> 考试结束 </a>";
    	   if(obj.status=='1' && sysdate>=obj.statime && sysdate<=obj.endtime && scid==''){
    	   //if(obj.status=='1'){
    		   button="<a class=\"btn btn-success btn-lg\" role=\"button\" href=\"<%=path%>/exam/toexam.do?pid="+obj.pid+"&qids="+obj.qids+"&pname="+obj.pname+"&endtime="+obj.endtime+"&ptimes="+obj.ptimes+" \"> 开始考试 </a>";
    	   }
    	   html+="<div class='jumbotron'>"+
				        "<h3>试卷名称:"+pname+"</h3>"+
				        "<p>考试时间:"+time+"</p>"+
				        "<p>试卷状态:"+status+"</p>"+
				        "<p>考生姓名:"+username+"</p>"+
				        scores+
				        "<p>"+button+"</p>"+
				   "</div>";
           }
           $("[class='container']").html(html);
   }
  
</script>

</head>
<body>
   <div class="container">
	   
   </div>
</body>
</html>