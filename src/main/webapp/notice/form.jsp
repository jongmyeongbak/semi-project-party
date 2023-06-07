<%@page import="java.net.URLEncoder"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
Integer auth = (Integer) session.getAttribute("auth");
if (auth == null || auth > 3) {
	response.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("새글등록", "utf-8"));
	return;
}
%>
<!doctype html>
<html lang="ko">
<head>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script>
        function toggleDateTimeInput() {
            let dateTimeInputs = document.querySelectorAll("#datetime_input > input");
            let now = document.querySelector('input[name="now"]:checked').value === "true";
            if (now) {
	            for (let input of dateTimeInputs) {
	           		input.className = "invisible";
	            	input.disabled = now;
	            }
            } else {
	            for (let input of dateTimeInputs) {
	            	input.removeAttribute("class");
	            	input.disabled = now;
	            }
            }
        }
    </script>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="notice"/>
</jsp:include>
<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
         	<h1 class="border bg-light fs-4 p-2">공지 등록폼</h1>
      	</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<%
			String err = request.getParameter("err");

			if ("empty".equals(err)) {
			%>
			<div class="alert alert-danger">
				<strong>작성 실패</strong> 제목 또는 본문이 비어있습니다.
			</div>
			<%
			}
			%>
			<p>제목과 내용을 입력하세요</p>		
			<form class="border bg-light p-3" method="post" action="insert.jsp">
				<div class="form-group mb-2">
					<label class="form-label">제목</label>
					<input type="text" class="form-control" name="title" />
				</div>
				<div class="form-group mb-2">
					<label class="form-label">내용</label>
					<textarea rows="5" class="form-control" name="content" ></textarea>
				</div>
				<div class="form-group mb-2 align-middle form-check-inline">
					<label class="form-label">발행 시간 </label>
			        <input type="radio" class="form-check-input ms-3" name="now" value="true" checked onclick="toggleDateTimeInput()"> 현재
			        <input type="radio" class="form-check-input ms-2" name="now" value="false" onclick="toggleDateTimeInput()"> 예약
			        <span id="datetime_input">
			        <%
					String dateStr = LocalDateTime.now().plusMinutes(10).toLocalDate().toString();
					%>
						<input type="date" name="date" value=<%=dateStr %> class="invisible" disabled>
						<input type="time" name="time" class="invisible" disabled>
			        </span>
				</div>
				<div class="form-group mb-2 row">
					<div class="col-6 text-start">
						<button type="button" class="btn btn-secondary btn-lg" onclick="history.back()">취소</button>
					</div>
					<div class="col-6 text-end">
						<button type="submit" class="btn btn-primary btn-lg">등록</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>