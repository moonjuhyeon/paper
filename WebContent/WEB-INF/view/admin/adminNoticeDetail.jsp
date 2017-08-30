<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.paper.dto.Notice_infoDTO" %>
<%
	Notice_infoDTO nDTO = (Notice_infoDTO) request.getAttribute("nDTO");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/include/head.jsp"%>
<script>

$(function(){
    $( "#paperList" ).sortable();
    $( "#paperList" ).disableSelection();

	$.ajax({
		url:"paperList.do",
		method:"post",
		dataType:"json",
		data: {'nNo' : <%=CmmUtil.nvl(nDTO.getNotice_no())%>},
		success:function(data){
			console.log(data)
			var contents = "";
			$.each(data, function(key,value){
				contents += "<li>";
				contents += "<div class='act-time' style='background-color:white;'>";
				contents += "<div class='activity-body act-in'>";
				contents += "<div class='text' style='height:150px;'>";
				contents += "<p class='attribution'>"+"<a href='#'>"+value.user_name+"</a>"+value.reg_dt +"</p>";
				contents += "<div>";
				contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_kor+"</p>";
				contents += "<input type='hidden' name='test' value='"+value.paper_kor+"'>";
				contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_eng+"</p>";
				contents += "<div style='display : inline; float:right';>";
				contents += "<button class='btn btn-primary' style='width:90px;'>다운로드</button>";
				contents += "</div>";
				contents += "</div>";
				contents += "</br>";
				contents += "<div style='float: right;'>";
				contents += "<select class='form-control' style='width:300px; display:inline;'>";
				contents += "<option>"+value.paper_ad+"</option>";
				contents += "<option>"+"합격"+"</option>";
				contents += "<option>"+"불합격"+"</option>";
				contents += "</select>";
				contents += "<button class='btn btn-primary' style='display:inline; width:90px'>확인</button>";
				contents += "</div>";
				contents += "</br>";
				contents += "</div>";
				contents += "</div>";
				contents += "</li>";
			})
			console.log(data.length);
			if(data.length==0){
				$('#paperList').html("<h3>접수된 논문이 없습니다.</h3>");
			}else{
			$('#paperList').html(contents);
			}
		}
		
	})
})

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공고 상세</title>
</head>
<body>
<%@include file="/include/naviBarAndasideBar.jsp"%>
	<!-- 회원가입 폼 시작-->
	<!--main content start-->
	<section id="main-content"> <section class="wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">
				<i class="fa fa-table"></i> 게시판
			</h3>
			<ol class="breadcrumb">
				<li><i class="fa fa-home"></i><a href="#">Login</a></li>
				<li><i class="fa fa-th-list"></i>공고</li>
			</ol>
		</div>
	</div>
	<!----------------------------------------------------- 공고 내용 시작----------------------------------------------->
	<div class="row">
		<div class="col-lg-12">
			<section class="panel"> <header class="panel-heading">공고 상세</header>
				<div class="panel-body">	
					<table class="table table-striped table-advance table-hover table-bordered">
						<tbody>
							<tr>
								<th width="10%"><center>제목</center></th>
								<th width="50%"><center><%=nDTO.getNotice_title() %></center></th>
								<th width="10%"><center>접수일</center></th>
								<th width="10%"><center><%=nDTO.getReception_date() %></center></th>
								<th width="10%"><center>종료일</center></th>
								<th width="10%"><center><%=nDTO.getEnd_date() %></center></th>
							</tr>
						</tbody>
					</table>
	<!----------------------------------------------------- 공고 내용 종료----------------------------------------------->		
				<div class="act-time">
					<div class="activity-body act-in">
						<ul class="nav nav-tabs">
							<li class="active"><a data-toggle="tab">등록현황 </a></li>
						</ul>
					</div>
				</div>
	<!----------------------------------------------------- 접수 내역 시작 ----------------------------------------------->
				<div class="act-time">
					<div class="activity-body act-in">
						<div class="text" style="height: 150px;">
							<p class="attribution">
								<a href="#">문주현<!-- 접수자 이름 --></a> 2017.08.21 18:00:00<!-- 접수 날자 -->
							</p>
							<p class="attribution" style="display: inline; font-size: 15px;">
								4차산업혁명 대비 벤처창업아이템 경진대회<!-- 한글 제목 -->
							</p>
							<div>
								<p class="attribution" style="display: inline; font-size: 15px;">
									Venture start-up item competition against 4th industrial revolution<!-- 영문 제목 -->
								</p>
								<div style="display: inline; float: right;">
									<button class="btn btn-primary" style="width: 90px;">다운로드</button>
								</div>
							</div>
							<br />
							<div style="float: right;">
								<select class="form-control" style="width: 300px; display: inline;">
									<option>합격</option>
									<option>불합격</option>
								</select>
								<button class="btn btn-primary" style="display: inline; width: 90px;">확인</button>
							</div>
						</div>
						<br/>
					</div>
				</div>
	<!----------------------------------------------------- 접수 내역 종료 ----------------------------------------------->
	<form action="noticeProc.do" method="post">
	
	<ul id="paperList"  style="	list-style: none;margin:0px; padding:0px;">
	
	</ul>
		<button type="submit">테스트</button>	
	</form>
					<div align="right">
						<button class="btn btn-primary" style="display: inline; width: 90px;">합격</button>
						<button class="btn btn-danger" style="display: inline; width: 90px;">불합격</button>
					</div>
				</div>
			</div>
			</section>
		</div>
	</div>
	</section> </section>

	<%@include file="/include/bottomJavaScript.jsp"%>
</body>
</html>