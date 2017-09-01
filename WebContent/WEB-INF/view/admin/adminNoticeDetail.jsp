<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.paper.dto.Notice_infoDTO" %>
<%
	Notice_infoDTO nDTO = (Notice_infoDTO) request.getAttribute("nDTO");
	String userNo = (String)session.getAttribute("ss_user_no");
	if(CmmUtil.nvl(userNo).equals("")){
		response.sendRedirect("userLogin.do");
	}
%>
<html>
<head>
<%@include file="/include/head.jsp"%>
<script>
var ad = "S";	// 셀렉트박스 기본 값
var n = "N";	// ajax List뷰 기본 값
function adFunc(a){
	ad = a;
}
$(function(){
  	ad="S";
 	nothingList();
 	
 	$('#all').click(function(){	// All 체크
 		if($('#all').prop("checked")){
 			$("input[name=upCheck]").prop("checked",true);
 		}else{
 			$("input[name=upCheck]").prop("checked",false);
 		}
 	})

})
function paperList(n){
	$.ajax({
		url:"paperList.do",
		method:"post",
		dataType:"json",
		data: {'nNo' : <%=CmmUtil.nvl(nDTO.getNotice_no())%>,
				'pAd' : n},
		success:function(data){
			var contents = "";
			$.each(data, function(key,value){
				contents += "<li>";
				contents += "<input type='checkbox' name='upCheck' value='"+value.paper_no+"'>";
				contents += "<div class='act-time' style='background-color:white;'>";
				contents += "<div class='activity-body act-in'>";
				contents += "<div class='text' style='height:150px;'>";
				contents += "<p class='attribution'>"+"<a href='#'>"+value.user_name+"</a>"+value.reg_dt +"</p>";
				contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_kor+"</p>";
				contents += "<br>";
				contents += "<div>";
				contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_eng+"</p>";
				contents += "<br>";
				contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_type+"</p>";
				contents += "<div style='display : inline; float:right';>";
				contents += "<form action='download.do' method='post' style='display:inline;'>"
				contents += "<input type='hidden' name='path' value='" + value.file_path + "'>"
				contents += "<input type='hidden' name='fileName' value='" + value.file_name + "'>"
				contents += "<input type='hidden' name='fileOrgName' value='" + value.file_org_name + "'>"
				contents += "<input type='submit' class='btn btn-primary' value='다운로드' style='width:90px;'>"
				//contents += "<button class='btn btn-primary' style='width:90px;'>다운로드</button>";
				contents += "</form>"
				contents += "</div>";
				contents += "</div>";
				contents += "</br>";
				contents += "<div style='float: right;'>";
				contents += "<select class='form-control' style='width: 300px; display: inline;' id='paperAd' onclick='adFunc(this.value);'>";
				contents += "<option value='S' selected>"+"선택하세요"+"</option>";
				contents += "<option value='N'>"+"심사중"+"</option>";
				contents += "<option value='A'>"+"합격"+"</option>";
				contents += "<option value='D'>"+"불합격"+"</option>";
				contents += "</select>";
				contents += "<button class='btn btn-primary' style='display:inline; width:90px' onclick='updateAd("+value.paper_no+","+<%=CmmUtil.nvl(nDTO.getNotice_no())%>+")'>확인</button>";
				contents += "</div>";
				contents += "</div>";
				contents += "</br>";
				contents += "</div>";
				contents += "</div>";
				contents += "</li>";
			})
			if(data.length==0){
				if(n=="N"){
				$('#paperList').html("<h3>심사중인 논문이 없습니다.</h3>");
				}else if(n=="A"){
				$('#paperList').html("<h3>합격된 논문이 없습니다.</h3>");
				}else{
				$('#paperList').html("<h3>불합격된 논문이 없습니다.</h3>");
				}
			}else{
			if(n=="A"){
				contents += "<input type='button' class='btn btn-primary' onclick='mergeDocxPage();' value='병합'>"
			}
			$('#paperList').html(contents);
			}
		}
		
	})
}
function nothingList(){
	n = "N";
	paperList(n);
}
function dropList(){
	n = "D";
	paperList(n);
}
function acceptList(){
	n = "A";
	paperList(n);
}
function updateAd(pNo, nNo){
	if(ad=="S"){
		alert("상태를 선택하세요");
		paperList(n);
		return false;
	}else{
	$.ajax({
		url : "paperAdUpdate.do",
		method : "post",
		dataType : "JSON",
		data : {'nNo' : nNo,
				'pNo' : pNo,
				'pAd' : ad,
				'pAdV' : n
				},
				success:function(data){
					var contents = "";
					$.each(data, function(key,value){
						contents += "<li>";
						contents += "<input type='checkbox' name='upCheck' value='"+value.paper_no+"'>";
						contents += "<div class='act-time' style='background-color:white;'>";
						contents += "<div class='activity-body act-in'>";
						contents += "<div class='text' style='height:150px;'>";
						contents += "<p class='attribution'>"+"<a href='#'>"+value.user_name+"</a>"+value.reg_dt +"</p>";
						contents += "<div>";
						contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_kor+"</p>";
						contents += "<br>";
						contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_eng+"</p>";
						contents += "<br>";
						contents += "<p class='attribution' style='display: inline; font-size:15px;'>"+value.paper_type+"</p>";
						contents += "<div style='display : inline; float:right';>";
						contents += "<form action='download.do' method='post' style='display:inline;'>"
						contents += "<input type='hidden' name='path' value='" + value.file_path + "'>"
						contents += "<input type='hidden' name='fileName' value='" + value.file_name + "'>"
						contents += "<input type='hidden' name='fileOrgName' value='" + value.file_org_name + "'>"
						contents += "<input type='submit' class='btn btn-primary' value='다운로드' >"
						//contents += "<button class='btn btn-primary' style='width:90px;'>다운로드</button>";
						contents += "</form>"
						contents += "</div>";
						contents += "</div>";
						contents += "</br>";
						contents += "<div style='float: right;'>";
						contents += "<select class='form-control' style='width: 300px; display: inline;' onclick='adFunc(this.value);'>";
						contents += "<option value='S' selected>"+"선택하세요"+"</option>";
						contents += "<option value='N'>"+"심사중"+"</option>";
						contents += "<option value='A'>"+"합격"+"</option>";
						contents += "<option value='D'>"+"불합격"+"</option>";
						contents += "</select>";
						contents += "<button class='btn btn-primary' style='display:inline; width:90px' onclick='updateAd("+value.paper_no+","+<%=CmmUtil.nvl(nDTO.getNotice_no())%>+")'>확인</button>";
						contents += "</div>";
						contents += "</div>";
						contents += "</br>";
						contents += "</div>";
						contents += "</div>";
						contents += "</li>";
					})
					if(data.length==0){
						if(n=="N"){
							$('#paperList').html("<h3>심사중인 논문이 없습니다.</h3>");
							}else if(n=="A"){
							$('#paperList').html("<h3>합격된 논문이 없습니다.</h3>");
							}else{
							$('#paperList').html("<h3>불합격된 논문이 없습니다.</h3>");
							}
					}else{
						if(n=="A"){
							contents += "<input type='button' class='btn btn-primary' onclick='mergeDocxPage();' value='병합'>"
						}
					$('#paperList').html(contents);
					}
				}	
		
	})
}
}
function mergeDocxPage(){
	var popUrl ="mergeDocxPage.do?nNo="+<%=nDTO.getNotice_no()%>+"&adV="+n;
	var popOption = "width=370,height=500, resizeble=yes, status=no;";
	window.open(popUrl,"",popOption);
}

function paper_check() {
	var checked = false;
	var check = $("input[name=upCheck]").val();
	var f = document.getElementById("f");
	var allupAd = $('#allupAd').val();
	if (check.length) {
		for (var i = 0; i < check.length; i++) {
			if (check[i].checked) {
				checked = true;
				break;
			}
		}
	}
	if (checked) {
		if (confirm("선택한 것들의 상태를 변경하시겠습니까?")) {
			f.submit();
		}
	}else{
		return false;
	}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공고 상세</title>
</head>
<body>
<%@include file="/include/naviBarAndasideBar.jsp"%>
	<!-- 회원가입 폼 시작-->
	<!--main content start-->
	<form action="download.do" method="post">
		<input type="hidden" name="path">
		<input type="hidden" name="fileName">
		<input type="hidden" name="fileOrgName">
	</form>
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
			<form name="f" id="f" action="updatePaperAdCheck.do" method="post" onsubmit="return paper_check()">
				<input type="hidden" name="nNo" value="<%=nDTO.getNotice_no()%>"> 
				<input type="checkbox" name="all" id="all"> 전체선택 
				<button class="btn btn-primary" style='float:right; width:90px;'>확인</button>
				<select class='form-control' style='width: 300px; display: inline; float:right;' name="allupAd" id="allupAd">
				<option value="S">선택하세요</option>
				<option value="N">심사중</option>
				<option value="A">합격</option>
				<option value="D">불합격</option>
				</select>
			</form>
				<br>
				<br>
	<!----------------------------------------------------- 공고 내용 종료----------------------------------------------->		
				<div class="act-time">
					<div class="activity-body act-in">
						<ul class="nav nav-tabs">
							<li class="active"><a data-toggle="tab" onclick="nothingList();">심사중 논문 </a></li>
							<li><a data-toggle="tab" onclick="dropList();">불합격 논문 </a></li>
							<li><a data-toggle="tab" onclick="acceptList();">합격 논문 </a></li>
						</ul>
					</div>
				</div>
	<!----------------------------------------------------- 접수 내역 시작 ----------------------------------------------->
				<div class="act-time">
					<div class="activity-body act-in">
						<div class="text" style="height: 150px;">
							<p class="attribution">
								<a href="#">문주현접수자 이름</a> 2017.08.21 18:00:00접수 날자
							</p>
							<p class="attribution" style="display: inline; font-size: 15px;">
								4차산업혁명 대비 벤처창업아이템 경진대회한글 제목
							</p>
							<div>
								<p class="attribution" style="display: inline; font-size: 15px;">
									Venture start-up item competition against 4th industrial revolution영문 제목
								</p>
								<br>
								<p class="attribution" style="display: inline; font-size: 15px;">
									구두발표영문 제목
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
	<ul id="paperList"  style="	list-style: none;margin:0px; padding:0px;">
	</ul>
				</div>
			</div>
			</section>
		</div>
	</div>
	</section> </section>
	<%@include file="/include/bottomJavaScript.jsp"%>
</body>
</html>