<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<% String path=request.getContextPath(); %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>考试页面</title>
		<link rel="stylesheet" href="<%=path %>/bootstrap/css/bootstrap.css" />
        <link rel="stylesheet" href="<%=path %>/css/exam.css"/>
        <script type="text/javascript" src="<%=path %>/js/jquery-3.2.1.min.js"></script>
        <script type="text/javascript">
	        var pid='${pid}';
	        var qids='${qids}';
	        var endtime='${endtime}';
	        var ptimes='${ptimes}';
	        var filename="";
	        
	         $(function(){
	        	 //倒计时 
	        	 setInterval("countdown()", 1000);
	        	 //判断技能题是否存在
	        	 checkFile();
	        	 //下载文件
	        	 downFile();
	        	 //答题卡
	        	 getCard();
	        	 //展示理论题
		         getQues();
	        	 //提交试卷
	        	 $("[class='btn btn-danger']").click(function(){
	        		 examAnswer();
	        	 })
	        	 //a();
	         })
	         function a(){
	        	 var winHeight = $(document).scrollTop();
	        	 
	        	 $(window).scroll(function() {
	        	      var scrollY = $(document).scrollTop();// 获取垂直滚动的距离，即滚动了多少
	        	      alert(scrollY);
		        	  if (scrollY > 200){ //如果滚动距离大于550px则隐藏，否则删除隐藏类
		        	      // $("#top").css({"margin-top": "100px"});
		        	  }
		        	  
		        	  /* if (scrollY > winHeight){
		        		  $("#top").removeCss({"margin-top"});
		        	  } 
		        	  else {
		        	      $('.top-title').addClass('showed');
		        	  }  */   
	        	  
	        	  });
	         }
	         //倒计时
	         function countdown(){
	        	 //当前时间
	        	 var current=new Date().getTime();
	        	 var time=endtime-current;
	        	 
	        	 if(time>0){
	        		 var hour=Math.floor(time/(3600*1000));
	        		 var minutes=Math.floor(time%(3600*1000)/(60*1000));
	        		 var seconds=Math.floor(time%(60*1000)/1000);
	        		 $("#countdown").text("在线考试倒计时: "+hour+"小时"+minutes+"分"+seconds+"秒");
	        	 }else {
	        		 //超时提交试卷
	        		 //examAnswer();
	        	 }
	         }
	         
	         //判断技能题是否存在
	         function checkFile(){
	        	 $.ajax({
	      		   type:"post",
	      		   url:"<%=path%>/exam/checkFile.do",
	      		   data:{"pid":pid},
	      		   dataType:"text",
	      		   success:function(res){
	      			   if(res!=null && res!=''){
	      				   filename=res.substr(res.lastIndexOf("\\")+1,res.length);
	      				   $("#skill").text(filename+"下载");
	      			   }else{
	      				   $("#skill").css("display","none");
	      				   filename="";
	      			   }
	      		   }
	      	    })
	         }
	         //文件下载 
	         function downFile(){
	        	 $("#skill").click(function(){
	        		 location.href="<%=path%>/exam/downFile.do?filename="+filename;
	        	 })
	         }
	         
	         //答题卡
	         function getCard(){
	        	 var arry=qids.split(",");
	        	 var cards="";
	        	 for(var i=0;i<arry.length;i++){
	        		 cards+="<button type=\"button\" class=\"btn btn-default\">"+(i+1)+"</button>";
	        	 }
	        	 $("#center").append(cards);
	         }
	         
	         //展示理论题
	         function  getQues(){
	        	 $.ajax({
		      		   type:"post",
		      		   url:"<%=path%>/exam/getQues.do",
		      		   data:{"qids":qids},
		      		   dataType:"json",
		      		   success:function(res){
		      			   //[
		      			      // {"id":418,"options":[{"id":0,"opcontent":"A、 int a=(double) 8.0","qid":0},{"id":0,"opcontent":"B、 byte b=(byte)(4+4)","qid":0},{"id":0,"opcontent":"C、 double d=2+3","qid":0},{"id":0,"opcontent":"D、 int n=(byte) 4","qid":0}],"qanswer":"B","qname":"下列属于强制类型转化的是","qscore":5.0,"qtype":"1"},
		      			      // {"id":423,"options":[{"id":0,"opcontent":"A、 switch 语句必须要有default","qid":0},{"id":0,"opcontent":"B、 switch 语句default必须写在最后","qid":0},{"id":0,"opcontent":"C、 switch 语句必须要有case标识符","qid":0},{"id":0,"opcontent":"D、 switch 语句必须要写break","qid":0}],"qanswer":"C","qname":"下列有关switch 语句描述正确的是 ","qscore":5.0,"qtype":"1"},
		      			      // {"id":923,"options":[{"id":0,"opcontent":"A、 继承","qid":0},{"id":0,"opcontent":"B、 封装","qid":0},{"id":0,"opcontent":"C、 多态","qid":0},{"id":0,"opcontent":"D、 抽象","qid":0}],"qanswer":"ABCD","qname":"java面向对象三大特征","qscore":5.0,"qtype":"2"},
		      			      // {"id":453,"options":[{"id":0,"opcontent":"A、 int[]  arry=new int[]{}","qid":0},{"id":0,"opcontent":"B、 int  arry=new int[]{}","qid":0},{"id":0,"opcontent":"C、 int[]  arry={‘a’,2,4}","qid":0},{"id":0,"opcontent":"D、  int  arry=new int[4]","qid":0}],"qanswer":"AC","qname":"下列数组格式正确的是","qscore":10.0,"qtype":"2"}
		      			    //]
		      			    var html="";
		      			    for(var i=0;i<res.length;i++){
		      			    	var obj=res[i];
		      			    	var type="";
		      			    	if(obj.qtype=="1"){
		      			    		type="单选题";
		      			    	}else if(obj.qtype=="2"){
		      			    		type="多选题";
		      			    	}else if(obj.qtype=="3"){
		      			    		type="判断题";
		      			    	}
		      	                var trs="";
		      	                for(var j=0;j<obj.options.length;j++){
		      	                	var op=obj.options[j];
		      	                	if(obj.qtype=="1" || obj.qtype=="3"){
		      	                		trs+="<tr><td style=\"padding-top: 5px;\"><input type=\"radio\" name=\"checkoption"+i+"\" class=\"optioncheck\" value="+op.opcontent+" onclick=\"if(this.c==1){this.c=0;this.checked=0}else this.c=1\" />"+op.opcontent+"</td></tr>";
		      	                	}else if(obj.qtype=="2"){
		      	                		trs+="<tr><td style=\"padding-top: 5px;\"><input type=\"checkbox\" name=\"checkoption"+i+"\" class=\"optioncheck\" value="+op.opcontent+"/>"+op.opcontent+"</td></tr>";
		      	                	}
		      	                }
		      			    	html+=" <div class=\"panel-heading\">"+(i+1)+".("+type+")."+obj.qname+"(分值"+obj.qscore+"分)<input type=\"text\" hidden=\"hidden\" value=\""+(obj.id+"-"+obj.qanswer)+"\"></div>"+
									  " <div class=\"panel-body\">"+
										    "<table >"+trs+"</table>"+
									   "</div>";
		      			    }
		      			    $("[class='panel panel-default']").html(html);
		      			    //关联答题卡 
		      			    joinCard();
		      		   }
		      	  })
	         }
	         //关联答题卡 
        	 function joinCard(){
        		 $("[class=\"optioncheck\"]").click(function(){
        			 
        			 $("#top").offset().top=600;
        			 
        			 var self=$(this);
        			 var text=self.parent().parent().parent().parent().parent().prev().text();
        			 //3.(多选题).java面向对象三大特征(分值5分)
        			 var index=text.substr(0,text.indexOf("."));
        			 var type=text.substr(text.indexOf("(")+1,text.indexOf(")")-3);
        			 
        			 if(self.prop("checked")){
        				 $("[class=\"btn btn-default\"]").eq(parseInt(index)-1).css("background-color","gray")
        			 }else{
        				 if(type=='多选题'){
        					 var n=$("[name=\"checkoption"+(parseInt(index)-1)+"\"]:checked").length;
        					 if(n==0){
        						 $("[class=\"btn btn-default\"]").eq(parseInt(index)-1).css("background-color","");
        					 }
        				 }else{
        					 $("[class=\"btn btn-default\"]").eq(parseInt(index)-1).css("background-color","");
        				 }
        			 }
        		 })
        	 }
	         
	         //提交试卷
	         function examAnswer(){
	        	 var arry=qids.split(",");
	        	 //我的答案  
	        	 var myidanswer="";
	        	 //分数
	        	 var sumscore=0;
	        	 
	        	 for(var i=0;i<arry.length;i++){
	        		 //正确答案 
	        		 var idanswer=$("[name=\"checkoption"+i+"\"]").parent().parent().parent().parent().parent().prev().children().val();
	        		 //alert(idanswer);//923-ABCD 
	        		 var id=idanswer.substr(0,idanswer.indexOf("-"));
	        		 //分数  3.(多选题).java面向对象三大特征(分值5分)
	        		 var text=$("[name=\"checkoption"+i+"\"]").parent().parent().parent().parent().parent().prev().text();
	        		 var score=text.substring(text.indexOf("分值")+2,text.length-2);
	        		 //题目类型 
	        		 var type=text.substring(text.indexOf("(")+1,text.indexOf(")"));
	        		 
	        		 var temp="";
	        		 $("[name=\"checkoption"+i+"\"]:checked").each(function(){
	        			 var self=$(this);
	        			 var v=self.val();
	        			 if(type=='判断题'){
	        				 temp=v;
	        			 }else{
	        				 temp+=v.substr(0,v.indexOf("、"));
	        			 }
	        		 })
	        		 //答案对比 ,计算总分 
	        		 if(idanswer==(id+"-"+temp)){
	        			 sumscore+=parseInt(score);
	        		 }
	        		 if(myidanswer==""){
	        			 myidanswer+=id+"-"+temp;
	        		 }else{
	        			 myidanswer+=","+id+"-"+temp;
	        		 }
	        		 
	        		 //alert("正确答案=="+idanswer+",我的答案=="+myidanswer);
	        	 }
	        	 alert("总分=="+sumscore);
	        	 //当前时间
	        	 var current=new Date().getTime();
	        	 var time=ptimes*3600*1000-(endtime-current);
	        	 var hour=Math.floor(time/(3600*1000));
	    		 var minutes=Math.floor(time%(3600*1000)/(60*1000));
	    		 var seconds=Math.floor(time%(60*1000)/1000);
	    		 //答卷使用时间 
	    		 var examtime=hour+"时"+minutes+"分"+seconds+"秒";
	    		 
	    		 //给表单隐藏组件赋值 
	    		 $("[name='pid']").val(pid);
	    		 $("[name='score']").val(sumscore);
	    		 $("[name='myidanswer']").val(myidanswer);
	    		 $("[name='usetime']").val(examtime);
	    		 //提交表单 
	    		 $("form").submit();
	         }
        </script>
	</head>
	<body>
		<div id="main">
			<div id="top">
				<div id="top_left">
					<span>考生姓名:${userinfo.username}</span>
					<span>试卷标题:${pname}</span>
					<span id="countdown" style="color:red"></span>
				</div>
				<div id="top_right">
					<button type="button" class="btn btn-success" id="skill" >技能题下载</button>
					<button type="button" class="btn btn-danger">提交试卷</button>
				</div>
			</div>
			<div id="center">
				<span>答题卡:</span>
				
			</div>
			<hr>
			<div id="bottom">
				<div class="panel panel-default">
		        </div>
			</div>
			
			<!-- 为了post提交，使用form表单提交数据保存成绩 -->
			<form action="<%=path%>/exam/save.do" method="post" >
			   <input type="hidden" name="pid" />
			   <input type="hidden" name="score" />
			   <input type="hidden" name="myidanswer" />
			   <input type="hidden" name="usetime" />
			</form>
		</div>
	</body>
</html>
    