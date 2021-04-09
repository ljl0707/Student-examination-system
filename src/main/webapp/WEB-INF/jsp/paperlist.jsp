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
   	   $("#stime").datetimepicker();
   	   $("#etime").datetimepicker();
   	   $("#starttime").datetimepicker();
	   
	   query();
	   
	   //查询
	   $("[class='btn btn-info']").click(function(){
		   query();
	   })
	   
	   //清空 
	   $("[class='btn btn-warning']").click(function(){
		   $("#name").val("");
		   $("#stime").val("");
		   $("#etime").val("");
		   $("#isvalid").val("");
		   query();
	   })
	
	   
	   //保存
	   $("[class='btn btn-primary']").click(function(){
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
				   url:"<%=path%>/paper/getObjById.do",
				   data:{"id":obj[0].value},
				   dataType:"json",
				   success:function(res){
					   //{"pid":1,"pname":"java一阶段考试","ptimes":1,"status":"1","url":"E:\\upload\\jdk安装.doc"}
					   alert(JSON.stringify(res));
					   $("#pname").val(res.pname);
					   $("[name='status'] option").each(function(){
						   if($(this).val()==res.status){
							   $(this).prop("selected",true);
						   }
					   });
					   $("#ptimes").val(res.ptimes);
					   $("#starttime").val(res.statime);
					   $("[name='pid']").val(res.pid);
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
				   url:"<%=path%>/paper/del.do",
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
	    var formData = new FormData($('#uploadForm')[0]); 
	    $.ajax({
	          type: 'post', 
	          url: "<%=path%>/paper/save.do",
	          data: formData,
	          dataType:"text",
	          cache: false, 
	          processData: false, 
		      contentType: false,
		      success:function(res){
		    	  if(res>0){
		    		  query(); 
		    		  $('#myModal').modal('hide');
		    	  }
		      }
	    })
   }
   
   function query(){
	   $.ajax({
		   type:"post",
		   url:"<%=path%>/paper/query.do",
		   data:{"name":$("#name").val(),"stime":$("#stime").val(),"etime":$("#etime").val(),"isvalid":$("#isvalid").val()},
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
		   var status=obj.status=='1'?'<font color="green">有效</font>':'<font color="red">无效</font>';
		   //E:\upload\jdk安装.doc
		   var filepath=obj.url;
		   var filename="";
		   if(filepath!=null && filepath!=''){
			   filename=filepath.substr(filepath.lastIndexOf("\\")+1,filepath.length);
		   }
		   html+="<tr>"+
		           "<td><input type='checkbox' value="+obj.pid+"></td>"+
			       "<td>"+obj.pname+"</td>"+
			       "<td>"+obj.ptimes+"</td>"+
			       "<td>"+obj.statime+"</td>"+
			       "<td>"+status+"</td>"+
			       "<td><a href='javaScript:downFile(\""+filename+"\")'>"+obj.url+"</a></td>"+
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
		   url:"<%=path%>/paper/query.do",
		   data:{"name":$("#name").val(),"stime":$("#stime").val(),"etime":$("#etime").val(),"isvalid":$("#isvalid").val(),"currentpage":currentpage},
		   dataType:"json",
		   success:function(res){
			   getTable(res);
		   }
	   })
   }
   
   function downFile(filename){
	   if(filename==null || filename==""){
		   return ;
	   }
	   location.href="<%=path%>/paper/down.do?filename="+filename;
   }
</script>

</head>
<body>
   

   <div class="container">
        <!-- 查询条件 -->
		<form class="form-inline" role="form" style="padding-top: 5px;">
			<div class="form-group">
				<label for="name">试卷名称</label> 
				<input type="text" class="form-control" id="name" placeholder="试卷名称" style="width: 150px;">
			</div>
			<div class="form-group">
				<label for="stime">开始时间</label> 
				<input type="text" class="form-control" id="stime" placeholder="开始时间" style="width: 150px;">
			</div>
			<div class="form-group">
				<label for="etime">结束时间</label> 
				<input type="text" class="form-control" id="etime" placeholder="结束时间" style="width: 150px;">
			</div>
			<div class="form-group">
			    <label for="isvalid">是否有效</label> 
				<select class="form-control" id="isvalid">
					<option value="">--请选择--</option>
					<option value="0">无效</option>
					<option value="1">有效</option>
				</select>
			</div>
			<!-- 按钮 -->
			<div class="form-group">
				<input type="button" class="btn btn-info" value="查询" />
				<input type="button" class="btn btn-warning" value="清空" />
				<input type="button" class="btn btn-success" value="修改" />
				<input type="button" class="btn btn-danger" value="批量删除" />
			</div>
			
		</form>
		<!-- 表格 -->
        <table class="table table-bordered table-hover">
            <thead>
				 <tr class='success'>
				    <th><input type="checkbox">全选</th>
					<th>试卷名称</th>
		            <th>考试时长(小时)</th>
		            <th>开始时间</th>
		            <th>是否有效</th>
		            <th>附件</th> 
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
	                <h4 class="modal-title" id="myModalLabel">试卷信息维护</h4>
	            </div>
	            <div class="modal-body">
					<form id="uploadForm" class="form-horizontal" role="form" enctype="multipart/form-data">
					    <input type="hidden" name="pid"/>
						<div class="form-group">
							<label for="username" class="col-sm-2 control-label">试卷名称</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" id="pname" name="pname" placeholder="请输入用户名">
							</div>
							
							<label for="usertype" class="col-sm-2 control-label">是否有效</label>
							<div class="col-sm-4">
								<select class="form-control" id="status" name="status">
							      <option value="0">无效</option>
							      <option value="1">有效</option>
							    </select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="age" class="col-sm-2 control-label">考试时长</label>
							<div class="col-sm-4">
								<input type="number" class="form-control" id="ptimes" name="ptimes" placeholder="考试时长">
							</div>
							
							<label for="age" class="col-sm-2 control-label">开始时间</label>
							<div class="col-sm-4">
								<input type="text" class="form-control" id="starttime" name="starttime" placeholder="开始时间">
							</div>
						 </div>
						
						 <div class="form-group">
				            <label for="age" class="col-sm-2 control-label">技能题目:</label>
							<div class="col-sm-4">
								<input type="file" class="form-control"  name="uploadfile" multiple="multiple">
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