<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String path=request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户列表</title>
<jsp:include page="top.jsp"/>

<script type="text/javascript">
   $(function(){
	   //时间控件
   	   $("#datetimepicker").datetimepicker();
	   //生成试卷 
	   $("[class='btn btn-info']").click(function(){
		   var stage=$("#stage").val();
		   var course=$("#course").val();
		   if(stage==null || stage==''){
			   alert("请选择阶段!");
			   return;
		   }
		   if(course==null || course==''){
			   alert("请选择专业!");
			   return;
		   }
		   createPaper();
	   })
	   
	   //清空 
	   $("[class='btn btn-warning']").click(function(){
		   $("#name").val("");
		   $("#type").val("");
		   $("#course").val("");
		   $("#stage").val("");
	   })
	   
	   //去保存试卷
	   $("[class='btn btn-primary']:eq(0)").click(function(){
		   var ids=$("[name='qids']").val();
		   if(ids==null || ids==''){
		    	alert("请先生成试卷");
		    	return;
		   }
		   $('#myModal').modal('show');
	   })
	   //保存试卷
	   $("[class='btn btn-primary']:eq(1)").click(function(){
		    var formData = new FormData($('#uploadForm')[0]); 
		    $.ajax({
	           type: 'post', 
	           url: "<%=path%>/paper/save.do",
	           data: formData,
	           dataType:"text",
	           cache: false, 
	           processData: false, 
		       contentType: false, 
	           }).success(function(data) { 
	               alert("上传成功");
	           }).error(function(data) { 
	               alert("上传失败");
	           });
	   })
   })
   
   //生成试卷
   function createPaper(){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/paper/creatPaper.do",
		   data:$("#queryForm").serialize(),
		   dataType:"json",
		   success:function(res){
			   //[{"id":382,"options":[{"id":494,"opcontent":"A、 int a","qid":0},{"id":495,"opcontent":"B、 double b=4.5","qid":0},{"id":496,"opcontent":"C、 boolean b=true","qid":0},{"id":497,"opcontent":"D、 float f=9.8","qid":0}],"qname":"下列变量定义错误的是:","qscore":5.0},{"id":387,"options":[{"id":388,"opcontent":"A、 double,int,long,float","qid":0},{"id":389,"opcontent":"B、 double,float,int,byte","qid":0},{"id":390,"opcontent":"C、 byte,long,double,float","qid":0},{"id":391,"opcontent":"D、 double,int,flaot,long","qid":0}],"qname":"下列数据类型的精度由高到低的顺序是","qscore":5.0},{"id":392,"options":[{"id":393,"opcontent":"A、 $java","qid":0},{"id":394,"opcontent":"B、 3_test","qid":0},{"id":396,"opcontent":"C、 hello-test","qid":0},{"id":397,"opcontent":"D、 my name","qid":0}],"qname":"下列哪些是合法的标识符 ","qscore":5.0},{"id":398,"options":[{"id":399,"opcontent":"A、 1011","qid":0},{"id":400,"opcontent":"B、 1101 ","qid":0},{"id":401,"opcontent":"C、 1001","qid":0},{"id":402,"opcontent":"D、 1101","qid":0}],"qname":"转化为二进制是：","qscore":5.0},{"id":408,"options":[{"id":409,"opcontent":"A、 ”+”","qid":0},{"id":410,"opcontent":"B、 ”++”","qid":0},{"id":411,"opcontent":"C、 ”=”","qid":0},{"id":412,"opcontent":"D、 ”%”","qid":0}],"qname":"下列哪些不属于算术运算符 ","qscore":5.0},{"id":413,"options":[{"id":414,"opcontent":"A、 3=3?true:false","qid":0},{"id":415,"opcontent":"B、 (1+1>0 && 3>2)?true:false","qid":0},{"id":416,"opcontent":"C、 4>3?false:true","qid":0},{"id":417,"opcontent":"D、 4>3:false?true","qid":0}],"qname":"下列三目运算符表达式正确的是:","qscore":5.0},{"id":418,"options":[{"id":419,"opcontent":"A、 int a=(double) 8.0","qid":0},{"id":420,"opcontent":"B、 byte b=(byte)(4+4)","qid":0},{"id":421,"opcontent":"C、 double d=2+3","qid":0},{"id":422,"opcontent":"D、 int n=(byte) 4","qid":0}],"qname":"下列属于强制类型转化的是","qscore":5.0},{"id":423,"options":[{"id":424,"opcontent":"A、 switch 语句必须要有default","qid":0},{"id":425,"opcontent":"B、 switch 语句default必须写在最后","qid":0},{"id":426,"opcontent":"C、 switch 语句必须要有case标识符","qid":0},{"id":427,"opcontent":"D、 switch 语句必须要写break","qid":0}],"qname":"下列有关switch 语句描述正确的是 ","qscore":5.0},{"id":428,"options":[{"id":429,"opcontent":"A、 public void getName{}","qid":0},{"id":430,"opcontent":"B、  int void getValue(int n)","qid":0},{"id":431,"opcontent":"C、 void getAge(){}","qid":0},{"id":432,"opcontent":"D、 getName(){}","qid":0}],"qname":"下列方法格式正确的是 ","qscore":5.0},{"id":433,"options":[{"id":434,"opcontent":"A、 int[]  arry=new int[]{}","qid":0},{"id":435,"opcontent":"B、 int  arry=new int[]{}","qid":0},{"id":436,"opcontent":"C、 int[]  arry={‘a’,2,4}","qid":0},{"id":437,"opcontent":"D、 int  arry=new int[4]","qid":0}],"qname":"下列数组格式正确的是","qscore":5.0},{"id":930,"options":[{"id":940,"opcontent":"A、选项A","qid":0},{"id":941,"opcontent":"B、选项A","qid":0},{"id":942,"opcontent":"C、选项A","qid":0},{"id":943,"opcontent":"D、选项A","qid":0}],"qname":"验证一","qscore":5.0},{"id":453,"options":[{"id":454,"opcontent":"A、 int[]  arry=new int[]{}","qid":0},{"id":455,"opcontent":"B、 int  arry=new int[]{}","qid":0},{"id":456,"opcontent":"C、 int[]  arry={‘a’,2,4}","qid":0},{"id":457,"opcontent":"D、  int  arry=new int[4]","qid":0}],"qname":"下列数组格式正确的是","qscore":10.0},{"id":458,"options":[{"id":459,"opcontent":"A、 3=3?true:false","qid":0},{"id":460,"opcontent":"B、  (1+1>0 && 3>2)?true:false","qid":0},{"id":461,"opcontent":"C、 4>3?false:true ","qid":0},{"id":462,"opcontent":"D、 4>3:false?true","qid":0}],"qname":"下列三目运算符表达式正确的是:","qscore":10.0},{"id":923,"options":[{"id":924,"opcontent":"A、 继承","qid":0},{"id":925,"opcontent":"B、 封装","qid":0},{"id":926,"opcontent":"C、 多态","qid":0},{"id":927,"opcontent":"D、 抽象","qid":0}],"qname":"java面向对象三大特征","qscore":5.0},{"id":931,"options":[{"id":944,"opcontent":"A、选择A","qid":0},{"id":945,"opcontent":"B、选择B","qid":0},{"id":946,"opcontent":"C、选择C","qid":0},{"id":947,"opcontent":"D、选择D","qid":0}],"qname":"验证二","qscore":5.0},{"id":463,"options":[{"id":464,"opcontent":"对","qid":0},{"id":465,"opcontent":"错","qid":0}],"qname":"java是一种语言吗","qscore":5.0},{"id":466,"options":[{"id":467,"opcontent":"对","qid":0},{"id":468,"opcontent":"错","qid":0}],"qname":"java不是一种语言吗","qscore":5.0},{"id":932,"options":[{"id":948,"opcontent":"对","qid":0},{"id":949,"opcontent":"错","qid":0}],"qname":"验证三","qscore":5.0}]
		       var html="";
			   var ids="";
			   var sum=0;
			   for(var i in res){
		    	   var obj=res[i];
		    	   if(ids==""){
		    		   ids+=obj.id;
		    	   }else{
		    		   ids+=","+obj.id;
		    	   }
		    	   sum+=obj.qscore;
		    	   var options="";
		    	   for(var j in obj.options){
		    		   options+="<tr>"+
					              "<td style='padding-top: 5px;'> "+obj.options[j].opcontent+"</td>"+
			   			         "</tr>";
		    	   }
		    	   html+="<div class='panel-heading'> "+(parseInt(i)+1)+"("+obj.qtype+")、"+obj.qname+"  (分值 "+obj.qscore+")</div>"+
		   			     "<div class='panel-body'>"+
		   			        "<table >"+options+"</table>"+
		   			     "</div>";
		       }
			   $("[name='qids']").val(ids); 
			   $("[class='panel panel-default']").html(html);
			   $("#sumscore").text(sum+"分");
		   }
		   
	   })
   }
</script>

</head>
<body>
   

   <div class="container">
        <!-- 查询条件 -->
		<form class="form-inline" role="form" style="padding-top: 5px;" id="queryForm">
			<div class="form-group">
				<label for="singlnum">单选题</label> 
				<input type="number" class="form-control" id="singlnum" name="singlnum" placeholder="单选题数量" style="width: 100px;">
			</div>
			<div class="form-group">
				<label for="morenum">多选题</label> 
				<input type="number" class="form-control" id="morenum" name="morenum" placeholder="多选题数量" style="width: 100px;">
			</div>
			<div class="form-group">
				<label for="judgenum">判断题</label> 
				<input type="number" class="form-control" id="judgenum" name="judgenum" placeholder="判断题数量" style="width: 100px;">
			</div>
			<div class="form-group">
			    <label for="stage">专业阶段</label>
				<select class="form-control" id="stage" name="stage">
				      <option value="">-请选择-</option>
				      <option value="4">第一阶段</option>
				      <option value="5">第二阶段</option>
				      <option value="6">第三阶段</option>
				      <option value="7">第四阶段</option>
				    </select>
			</div>
			<div class="form-group">
			    <label for="course" >专业类别</label>
				<select class="form-control" id="course" name="course">
				      <option value="">-请选择-</option>
				      <option value="8">java</option>
				      <option value="9">大数据</option>
				      <option value="10">UI设计</option>
				      <option value="11">AI智能</option>
				      <option value="12">网络营销</option>
				    </select>
			</div>
			<!-- 按钮 -->
			<div class="form-group">
				<input type="button" class="btn btn-info" value="生成试卷" />
				<input type="button" class="btn btn-warning" value="清空" />
				<input type="button" class="btn btn-primary" value="保存试卷" />
				总分:<span id="sumscore" style="color: red;font-size: 14px;"></span>
			</div>
		</form>
		<hr>
		<div class="panel panel-default">
			    
		</div>
   </div>
   
    <!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="myModalLabel">用户信息维护</h4>
	            </div>
	            <div class="modal-body">
					<form id="uploadForm" class="bs-example bs-example-form" role="form"  method="post" enctype="multipart/form-data">
				        <div class="input-group">
				            <span class="input-group-addon">试卷描述:</span>
				            <input id="pname" name="pname" type="text" class="form-control" placeholder="请输入试卷名称" />
				        </div>
				        <br>
				        <div class="input-group">
				            <span class="input-group-addon">考试时长:</span>
				            <input id="ptimes" name="ptimes" type="text" class="form-control" placeholder="请输入考试时长"/>
				            <span class="input-group-addon">hours</span>
				        </div>
				        <br>
				        <div class="input-group">
				            <span class="input-group-addon">开始时间:</span>
				            <input id="datetimepicker" name="starttime" type="text" class="form-control" placeholder="请输入考试开始时间"/>
				        </div>
				        <br>
				         <div class="input-group">
				            <span class="input-group-addon">技能题目:</span>
				            <input type="file" id="file" name="uploadfile" multiple="multiple" />
				        </div>
				        <br>
				        <input type="hidden" name="qids"/>
				    </form>
				</div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	                <button type="button" class="btn btn-primary">提交更改</button>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal -->
	</div>
</body>
</html>