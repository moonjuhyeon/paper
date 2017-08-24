<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% request.setCharacterEncoding("euc-kr"); %>
<html>
<head>
<%@include file="/include/head.jsp"%>
<script>
$(document).ready(function(){
    // ����� ��Ű���� �����ͼ� ID ĭ�� �־��ش�. ������ �������� ��.
    var userInputId = getCookie("userInputId");
    $("input[name='email']").val(userInputId); 
     
    if($("input[name='email']").val() != ""){ // �� ���� ID�� �����ؼ� ó�� ������ �ε� ��, �Է� ĭ�� ����� ID�� ǥ�õ� ���¶��,
        $("#idSaveCheck").attr("checked", true); // ID �����ϱ⸦ üũ ���·� �α�.
    }
     
    $("#idSaveCheck").change(function(){ // üũ�ڽ��� ��ȭ�� �ִٸ�,
        if($("#idSaveCheck").is(":checked")){ // ID �����ϱ� üũ���� ��,
            var userInputId = $("input[name='email']").val();
            setCookie("userInputId", userInputId, 7); // 7�� ���� ��Ű ����
        }else{ // ID �����ϱ� üũ ���� ��,
            deleteCookie("userInputId");
        }
    });
     
    // ID �����ϱ⸦ üũ�� ���¿��� ID�� �Է��ϴ� ���, �̷� ���� ��Ű ����.
    $("input[name='email']").keyup(function(){ // ID �Է� ĭ�� ID�� �Է��� ��,
        if($("#idSaveCheck").is(":checked")){ // ID �����ϱ⸦ üũ�� ���¶��,
            var userInputId = $("input[name='email']").val();
            setCookie("userInputId", userInputId, 7); // 7�� ���� ��Ű ����
        }
    });
});
 
function setCookie(cookieName, value, exdays){
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
    document.cookie = cookieName + "=" + cookieValue;
}
 
function deleteCookie(cookieName){
    var expireDate = new Date();
    expireDate.setDate(expireDate.getDate() - 1);
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}
 
function getCookie(cookieName) {
    cookieName = cookieName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cookieName);
    var cookieValue = '';
    if(start != -1){
        start += cookieName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cookieValue = cookieData.substring(start, end);
    }
    return unescape(cookieValue);
}


</script>
<script>
function doJoin(){
	location.href = "userJoin.do";	
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�α���</title>
</head>
<body class="">
	<div class="container">
		<form class="login-form" action="userLoginProc.do" method="post">
			<div class="login-wrap">
				<p class="login-img">
					<i class="icon_lock_alt"></i>
				</p>
				<div class="input-group">
					<span class="input-group-addon"><i class="icon_profile"></i></span>
					<input type="text" class="form-control" placeholder="�̸���" autofocus name="email">
				</div>
				<div class="input-group">
					<span class="input-group-addon"><i class="icon_key_alt"></i></span>
					<input type="password" class="form-control" placeholder="��й�ȣ" name="password">
				</div>
				<label class="checkbox"> <input type="checkbox" id="idSaveCheck"
					value="remember-me"> ���̵����ϱ� <span class="pull-right">
						<a href="#"> ���̵�/��й�ȣã��</a>
				</span>
				</label>
				<button class="btn btn-primary btn-lg btn-block" type="submit">�α���</button>
				<button class="btn btn-info btn-lg btn-block" type="button" Onclick="doJoin()">ȸ������</button>
			</div>
		</form>
		<div class="text-right">
			<div class="credits"></div>
		</div>
	</div>
	<%@include file="/include/bottomJavaScript.jsp"%>
</body>
</html>