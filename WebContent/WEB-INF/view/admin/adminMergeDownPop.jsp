<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.paper.dto.Notice_infoDTO" %>
<%@ page import="com.paper.util.CmmUtil" %>
<%
	Notice_infoDTO nDTO = (Notice_infoDTO) request.getAttribute("nDTO");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
.chats .by-me .chat-content {
	margin-left: 0px;
}

.chats .by-me .chat-meta {
	font-size: 20px;
	color: #999;
	font-weight: bold;
}

.btn-merge {
	width: 100px;
	font-size: 17px;
}
</style>

<script>
function doSubmit(f){
	if(confirm("���� �Ͻðڽ��ϱ�?")){
		f.submit();
		window.close;
		return true;
	}else{
		return false;
	}
}
</script>
<%@include file="/include/head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�������� �ٿ�ε�</title>
</head>
<body>
	<div class="row">

		<div class="col-lg-9 col-md-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>
						<i class="fa fa-flag-o red"></i><strong><%=nDTO.getNotice_title() %></strong>
					</h2>
				</div>
				<!-- <form name="f" action="mergeDocxProc.do" method="post" onsubmit='return doSubmit(this)'> -->
				<div class="panel-body">
					�ٿ�ε� ����
										<br>
					<%if(nDTO.getFile_name().equals("")){%>
						<strong>���յ� ������ �����ϴ�.</strong>
					<% }else{%>
					��� : <%=nDTO.getFile_path()%><%=nDTO.getFile_name()%>
					<%}%>
					
					<div class="widget-foot">
						<center>
						<!-- <button type="submit" class="btn btn-info btn-merge">����</button> -->
						</center>
					</div>
				</div>
				<!-- </form> -->

			</div>

		</div>
		<!--/col-->

		<%@include file="/include/bottomJavaScript.jsp"%>
</body>
</html>