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
		   $("#usertype").val("");
		   query();
	   })
	   
	   //增加
	   $("[class='btn btn-primary']:eq(0)").click(function(){
		   //弹出模态框
		   $("[name='id']").val("");
		   $("[name='username']").val("");
		   $('#myModal').modal('show');
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
				   url:"<%=path%>/user/getObjById.do",
				   data:{"id":obj[0].value},
				   dataType:"json",
				   success:function(res){
					   //{"age":123,"id":"582","pwd":"1","sex":"1","tel":"13839018225","username":"A","usertype":0}
					   $("[name='username']").val(res.username);
					   $("[name='usertype'] option").each(function(){
						   if($(this).val()==res.usertype){
							   $(this).prop("selected",true);
						   }
					   });
					   $("[name='pwd']").val(res.pwd);
					   $("[name='tel']").val(res.tel);
					   $("[name='age']").val(res.age);
					   $("[name='sex']").each(function(){
						   if($(this).val()==res.sex){
							   $(this).prop("checked",true);
						   }
					   })
					   $("[name='id']").val(res.id);
					   $('#myModal').modal('show');
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
				   url:"<%=path%>/user/del.do",
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
		   url:"<%=path%>/user/save.do",
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
		   url:"<%=path%>/user/query.do",
		   data:{"name":$("#name").val(),"usertype":$("#usertype").val()},
		   dataType:"json",
		   success:function(res){
			   getTable(res);
		   }
	   })
   }
   
   function getTable(res){
	   var html="";
	   for(var i in res.list){
		   var obj=res.list[i];
		   var sex=obj.sex==1?'男':'女';
		   var usertype=obj.usertype==1?"学生":"管理员";
		   html+="<tr>"+
		           "<td><input type='checkbox' value="+obj.id+"></td>"+
			       "<td>"+obj.username+"</td>"+
			       "<td>"+usertype+"</td>"+
			       "<td>"+obj.age+"</td>"+
			       "<td>"+sex+"</td>"+
			       "<td>"+obj.tel+"</td>"+
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
		   url:"<%=path%>/user/query.do",
		   data:{"name":$("#name").val(),"usertype":$("#usertype").val(),"currentpage":currentpage},
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
				<label for="name">用户名称</label> 
				<input type="text" class="form-control" id="name" placeholder="请输入用户名称">
			</div>
			<label for="name">用户类别</label> 
			<div class="form-group">
				<select class="form-control" id="usertype">
					<option value="">--请选择--</option>
					<option value="0">管理员</option>
					<option value="1">学生</option>
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
					<th>用户名</th>
		            <th>用户类型</th>
		            <th>年龄</th>
		            <th>性别</th>
		            <th>电话</th> 
		         </tr>
			</thead>
			<tbody>
			
			</tbody>
        </table>
        <!-- 分页 -->
        <div style="margin-top: 10px;" id="page">
		         
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
					<form class="form-horizontal" role="form">
					    <input type="hidden" name="id"/>
						<div class="form-group">
							<label for="username" class="col-sm-2 control-label">用户名</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名">
							</div>
							
							<label for="usertype" class="col-sm-2 control-label">用户类型</label>
							<div class="col-sm-4">
								<select class="form-control" id="usertype" name="usertype">
							      <option value="0">管理员</option>
							      <option value="1">学生</option>
							    </select>
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 control-label">性别</label>
							<div class="col-sm-4">
								<div class="radio ">
								    <label>
										<input type="radio" name="sex"  value="1" checked> 男
									</label>
									<label>
									    <input type="radio" name="sex"  value="0" > 女
									</label>
								</div>
							</div>
							
							<label for="age" class="col-sm-2 control-label">年龄</label>
							<div class="col-sm-4">
								<input type="number" class="form-control" id="age" name="age" placeholder="请输入年龄">
							</div>
						 </div>
						
						 <div class="form-group">
							<label for="tel" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" id="tel" name="tel" placeholder="请输入手机号">
							</div>
							
							<label for="pwd" class="col-sm-2 control-label">密码</label>
							<div class="col-sm-4">
								<input type="password" class="form-control" id="pwd" name="pwd" placeholder="请输入密码">
							</div>
						 </div>
						 
						
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