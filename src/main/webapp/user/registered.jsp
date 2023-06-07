<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="ko">
<head>
<title>회원가입 완료</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<style type="text/css">
.btn.btn-xs {--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;}

.btn-custom {
    width: 100%;
    margin-top: 20px;
    
}
</style>
</head>
<body>
<div class="container my-3">
    <div class="row mb-3">
        <div class="col-12">
            <h1 class="border bg-light fs-4 p-2">회원가입 완료</h1>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-12">
            <p>회원가입이 완료되었습니다.</p>
            <a href="../login-form.jsp" class="btn btn-custom btn-outline-primary btn-xs">로그인하기</a>
            <a href="../home.jsp" class="btn btn-custom btn-outline-primary btn-xs">홈으로 돌아가기</a>
        </div>
    </div>
</div>
</body>
</html>
