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
	   query();
	   
	   //查询
	   $("[class='btn btn-info']").click(function(){
		   query();
	   })
	   
	   //清空 
	   $("[class='btn btn-warning']").click(function(){
		   $("#name").val("");
		   $("#type").val("");
		   $("#course").val("");
		   $("#stage").val("");
		   query();
	   })
	   
	   //增加
	   $("[class='btn btn-primary']:eq(0)").click(function(){
		   //弹出模态框
		   /* $("[name='id']").val("");
		   $("[name='username']").val(""); */
		   //$('#myModal').modal('show');
		   location.href="<%=path%>/page/toAdd.do";
	   })
	   
	   //保存
	   $("[class='btn btn-primary']:eq(1)").click(function(){
		   save();
	   })
	   
	   //第一复选框
	   $("[type='checkbox']:eq(0)").click(function(){
		   if($(this).prop("checked")){
			   $("[type='checkbox']:not(:first)").prop("checked",true);
		   }else{
			   $("[type='checkbox']:not(:first)").prop("checked",false);
		   }
	   })
	   
	   //修改
	   $("[class='btn btn-success']").click(function(){
		   var obj=$("[type='checkbox']:not(:first):checked");
		   var len=obj.length;
		   if(len==0){
			   alert("请选择要修改的数据");
		   }else if(len>1){
			   alert("只能选择一条数据进行修改!");
		   }else{
			   //通过ID 查询要修改的数据，展示到模态框的表单中 
			   $.ajax({
				   type:"post",
				   url:"<%=path%>/page/getObjById.do",
				   data:{"id":obj[0].value},
				   dataType:"json",
				   success:function(res){
					   
				   }
			   })
		   }
	   })
	   
	   //批量删除
	   $("[class='btn btn-danger']").click(function(){
		   var ids="";
		   $("[type='checkbox']:not(:first)").each(function(){
			   if($(this).prop("checked")){
				   if(ids==""){
					   ids+=$(this).val();
				   }else{
					   ids+=","+$(this).val();
				   }
			   }
		   })
		   if(ids==""){
			   alert("请选择要删除的数据");
		   }else{
			   $.ajax({
				   type:"post",
				   url:"<%=path%>/page/del.do",
				   data:{"ids":ids},
				   dataType:"text",
				   success:function(res){
					   if(res>0){
						   query();
					   }
				   }
			   })
		   }
	   })
   })
   
   function save(){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/page/save.do",
		   data:$("[class='form-horizontal']").serialize(),
		   dataType:"text",
		   success:function(res){
			   if(res>0){
				   $('#myModal').modal('hide');
				   query();
			   }
		   }
	   })
   }
   
   function query(){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/page/query.do",
		   data:{"name":$("#name").val(),"type":$("#type").val(),"course":$("#course").val(),"stage":$("#stage").val()},
		   dataType:"json",
		   success:function(res){
			   getTable(res);
		   }
	   })
   }
   
   function getTable(res){
	   //{"count":10,"pagesize":10,"currentpage":1,"list":[{"id":382,"qanswer":"A","qcourse":"java","qname":"下列变量定义错误的是:","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":387,"qanswer":"B","qcourse":"java","qname":"下列数据类型的精度由高到低的顺序是","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":392,"qanswer":"A","qcourse":"java","qname":"下列哪些是合法的标识符 ","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":398,"qanswer":"B","qcourse":"java","qname":"转化为二进制是：","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":408,"qanswer":"B","qcourse":"java","qname":"下列哪些不属于算术运算符 ","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":413,"qanswer":"B","qcourse":"java","qname":"下列三目运算符表达式正确的是:","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":418,"qanswer":"B","qcourse":"java","qname":"下列属于强制类型转化的是","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":423,"qanswer":"C","qcourse":"java","qname":"下列有关switch 语句描述正确的是 ","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":428,"qanswer":"C","qcourse":"java","qname":"下列方法格式正确的是 ","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"},{"id":433,"qanswer":"C","qcourse":"java","qname":"下列数组格式正确的是","qscore":5.0,"qstage":"第一阶段","qtype":"单选题"}],"allpage":1}
	   var html="";
	   for(var i in res.list){
		   var obj=res.list[i];
		   html+="<tr>"+
		           "<td><input type='checkbox' value="+obj.id+"></td>"+
			       "<td>"+obj.qname+"</td>"+
			       "<td>"+obj.qtype+"</td>"+
			       "<td>"+obj.qcourse+"</td>"+
			       "<td>"+obj.qstage+"</td>"+
			       "<td>"+obj.qscore+"</td>"+
			       "<td>"+obj.qanswer+"</td>"+
			      "</tr>";
	   }
	   $("tbody").html(html);
	   
	   //分页展示信息
	   var page="总记录数 "+res.count+" ,每页 "+res.pagesize+"条,总页数"+res.allpage+", 当前第 "+res.currentpage+"页 "+ 
			    "<a href='javaScript:turnpage(1)'>首页</a>"+ 
			    "<a href='javaScript:turnpage("+(res.currentpage-1)+")'>上一页</a>"+
			    "<a href='javaScript:turnpage("+(res.currentpage+1)+")'>下一页</a>"+
			    "<a href='javaScript:turnpage("+res.allpage+")'>末页</a>";
			    
	   $("#page").html(page);
	   
   }
   
   function turnpage(currentpage){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/page/query.do",
		   data:{"name":$("#name").val(),"type":$("#type").val(),"course":$("#course").val(),"stage":$("#stage").val(),"currentpage":currentpage},
		   dataType:"json",
		   success:function(res){
			   getTable(res);
		   }
	   })
   }
</script>

</head>
<body>
   

   <div class="container">
        <!-- 查询条件 -->
		<form class="form-inline" role="form" style="padding-top: 5px;">
			<div class="form-group">
				<label for="name">题目名称</label> 
				<input type="text" class="form-control" id="name" placeholder="请输入题目名称">
			</div>
			
			<div class="form-group">
			    <label for="type" >题目类型</label>
				<select class="form-control" id="type" name="type">
				      <option value="">-请选择-</option>
				      <option value="1">单选</option>
				      <option value="2">多选</option>
				      <option value="3">判断</option>
				    </select>
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
				<input type="button" class="btn btn-info" value="查询" />
				<input type="button" class="btn btn-warning" value="清空" />
				<input type="button" class="btn btn-primary" value="增加" />
				<input type="button" class="btn btn-success" value="修改" />
				<input type="button" class="btn btn-danger" value="批量删除" />
			</div>
			
		</form>
		<!-- 表格 -->
        <table class="table table-bordered table-hover">
            <thead>
				 <tr class='success'>
				    <th><input type="checkbox">全选</th>
					<th>题目名称</th>
		            <th>题目类型</th>
		            <th>专业类别</th>
		            <th>专业阶段</th>
		            <th>分值</th>
		            <th>答案</th>
		         </tr>
			</thead>
			<tbody>
			
			</tbody>
        </table>
        <!-- 分页 -->
        <div style="margin-top: 10px;" id="page">
		         
	    </div>
   </div>
   
</body>
</html>