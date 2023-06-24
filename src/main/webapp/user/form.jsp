<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String err = request.getParameter("err");
%>
<!doctype html>
<html lang="ko">
<head>
<title>회원가입</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="register"/>
</jsp:include>
<div class="container">
	<div class="row mb-3">
    	<div class="col-12">
        	<h1 class="border bg-light fs-4 p-2">회원가입</h1>
      	</div>
   	</div>
   	<div class="row mb-3">
   		<div class="col-12">
   			<p>사용자 정보를 입력하고 등록하세요.</p>
<%
	if ("id".equals(err)) {
%>
		<div class="alert alert-danger">
			<strong>회원가입 실패</strong> 아이디가 이미 사용중입니다.
		</div>
<%
	} else if ("email".equals(err)){
%>
		<div class="alert alert-danger">
			<strong>회원가입 실패</strong> 이메일이 이미 사용중입니다.
		</div>
<%
	}
%>
			<form class="border bg-light p-3" method="post" action="insert.jsp">
				<div class="form-group mb-2">
   					<div class="form-label">성별</div>
   					<div class="form-check form-check-inline">
  						<input class="form-check-input" type="radio" id="radioM" name="gender"  value="M" checked="checked">
  						<label class="form-check-label" for="radioM">남자</label>
					</div>
					<div class="form-check form-check-inline">
  						<input class="form-check-input" type="radio" id="radioF" name="gender" value="F">
  						<label class="form-check-label" for="radioF
  						">여자</label>
					</div>
   				</div>
   				<div class="form-group mb-2">
   					<label class="form-label">아이디</label>
   					<input type="text" class="form-control" name="id" required />
   				</div>
   				<div class="form-group mb-2">
   					<label class="form-label">비밀번호</label>
   					<input type="password" class="form-control" name="password" required />
   				</div>
   				
   				<div class="form-group mb-2">
   					<label class="form-label">이름</label>
   					<input type="text" class="form-control" name="name" required />
   				</div>
   				<div class="form-group mb-2">
   					<label class="form-label">닉네임</label>
   					<input type="text" class="form-control" name="nickName" required />
   				</div>
				<div class="form-group mb-2">
					<label for="birthdate" class="form-label">생년월일</label> 
					<input type="text" class="form-control" id="datepicker" name="birthdate" class="form-control" required />
				</div>
				<div class="form-group mb-2">
   					<label class="form-label">이메일</label>
   					<input type="email" class="form-control" name="email" />
   				</div>
   				<div class="form-group mb-2">
					<label class="form-label">전화번호</label>
					<input type="tel" id="phone-number" class="form-control" name="tel" placeholder="예) 000-0000-0000" 
						   pattern="\d{3}-\d{4}-\d{4}" title="000-0000-0000형식으로 입력하세요." />
				</div>   				
   				<div class="text-end">
   					<button type="submit" class="btn btn-primary">회원가입</button>
				</div>
			</form>
   		</div>
	</div>
</div>
<script>
	$(function() {
		$("#datepicker").datepicker({
			dateFormat: "yy-mm-dd",
			changeYear: true,
			changeMonth: true,
			showMonthAfterYear:true,
			monthNamesShort: ['1월','2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			yearRange: "c-150:c+150",
			maxDate: "0D"
		});
	});
</script>
</body>
</html>