<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String nNo = (String) request.getAttribute("nNo");
%>
<html>
<head>
<%@include file="/include/head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
	select.selectForm{
		height:40px;
		font-size:18px;
	}
	a.submit-btn{
		margin-top : 15px;
		width:100px;
		height: 40px;
		font-size: 18px;
	}
</style>

<script>
	var writerCount = 1;
	function writerAdd(){
		writerCount++;
		var writerForm = "";
		writerForm += "<div class='form-group' id='form"+writerCount+"'>";
		writerForm += "<label>저자정보 <a>*</a></label>";
		writerForm += "<input type='text' placeholder='이름 입력' class='form-control Sub-Txt' name='name'>";
		writerForm += "<input type='text' placeholder='이메일 입력' class='form-control Sub-Txt' name='email'>";
		writerForm += "<input type='text' placeholder='소속 입력' class='form-control Sub-Txt'name='belong'>";
		writerForm += "<a class='btn btn-default' onclick='writerDel("+writerCount+")'>제거</a>";
		writerForm += "<hr>";
		writerForm += "</div>";
		
		$('#writerGroup').append(writerForm);
	}
	function writerDel(count){
		writerCount--;	
		$('#form'+count).remove();
	}
	function doSubmit(f){
		if(confirm("제출하시겠습니까?")){
			$('#writerSize').val(writerCount);
			if(checkRadio()){
				alert("'구두발표' 또는 '포스터 발표'를 선택해 주세요");
				return false;
			}
			if(checkExtended()){
				alert(".docx 파일만 업로드 가능합니다.");
				f.paper.focus();
				return false;
			}
			return true;
		}else{
			return false;
		}
		
	}
	
	function checkExtended(){
		var fileName = document.getElementById('paper').value;
		var extended = fileName.slice(fileName.indexOf(".")+1).toLowerCase();
		console.log(extended);
		var result = false;
		if(extended != "docx"){
			result = true;
		}
		return result;
	}
	
	function checkRadio(){
		var r = document.getElementsByName('pType');
		var result = true;
		for(var i = 0; i< r.length;i++){
			if(r[i].checked){
				result = false;
			}
		}
		return result;
	}
</script>
<title>공고 등록</title>
</head>
<body>
	<%@include file="/include/naviBarAndasideBar.jsp"%>
	<form class="form" action="paperRegProc.do" method="post" name="f" onsubmit='return doSubmit(this)' enctype="multipart/form-data">
		<section id="main-content"> <section class="wrapper">
		<div class="row">
			<div class="col-lg-12">
				<h3 class="page-header">
					<i class="icon_document_alt"></i>공고 관리
				</h3>
				<ol class="breadcrumb">
					<li><i class="icon_document_alt"></i><a href="#">공고 리스트</a></li>
					<li><i class="icon_document_alt"></i><a href="#">공고 등록</a></li>
					<li><i class="icon_document_alt"></i>공고 제출</li>
				</ol>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<section class="panel"> <header class="panel-heading">
				공고 제출 </header>
				<div class="panel-body">
					<div class="form-group">
						<label>한글 제목 <a>*</a></label> <input type="text" class="form-control Sub-Txt" name="korName" required="required">
						<hr>
					</div>
					<div class="form-group">
						<label>영문 제목 <a>*</a> </label> <input type="text" class="form-control Sub-Txt" name="engName" required="required">
						<hr>
					</div>
					<div class="form-group">
						<label>발표 형식 <a>*</a> </label>
						<br>
						<label class="radio-inline"><input type="radio" name="pType" value="O">구두발표</label>
						<label class="radio-inline"><input type="radio" name="pType" value="P">포스터발표</label>
					</div>
					<div class="form-group">
						<label class="block">논문 첨부 <a>*</a></label> <input type="file"
							class="form-control subTxt Sub-Txt" name="paper" id="paper" required="required">
						<hr>
					</div>
					<div id="writerGroup">
						<div class="form-group" id="form1">
							<label>저자 정보 <a>*</a></label> 
							<input type="text" placeholder="이름 입력" class="form-control Sub-Txt" name="name" required="required">
							<input type="text" placeholder="이메일 입력" class="form-control Sub-Txt" name="email" required="required">
							<input type="text" placeholder="소속 입력" class="form-control Sub-Txt" name="belong" required="required">
							<hr>
						</div>
					</div>
					<div class="form-group btn-right">
						<a class="btn btn-primary" onclick="writerAdd()">추가</a>
					</div>
					</div>
				</div>
				<input type="hidden" name="writerSize" id="writerSize">
			</div>
			<input type="submit" class="btn btn-primary btn-right" value="제출 하기" >
		</section>
		</section>
		</section>
		<input type="hidden" name="nNo" value="<%=nNo%>">
	</form>
	<%@include file="/include/bottomJavaScript.jsp"%>
</body>
</html>