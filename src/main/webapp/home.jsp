<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="dao.AdminNoticeDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
//samllnotice 로직
final int first = 1;
final int last = 3;
AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
List<Board> adminNoticeList = adminNoticeDao.getNotices("N", first, last);
//로그인 로직
String loginId = (String) session.getAttribute("loginId");
%>
<!doctype html>
<html lang="ko">
<head>
<title>파티홈입니다.</title>
<style >
	
	div.smallnotice {
  		position: relative;
  		top: 50px;
 		left: 160px;
  		padding: 10px; 
	}
	
	div.smallpartylist{
		position: relative;
		padding: 10px;
		top: 110px;
		left: 130px;
	}
	div.text-end{
		position: relative;
		margin-top: 20px;
	}
	thead {
		font-size : 15px;
		text-align: center;
	}
	tbody {
		font-size : 15px;
		text-align: center;
	}
	div.box-container {
 		display: flex;
  		flex-wrap: wrap;
 		margin-top: 50px;
 		justify-content: center;
	}
	
	div.background {
		background-color: rgb(237, 246, 255);
		border-radius: 70px;
	}

	div.box {
  		width: 15%;
  		height: 300px;
  		margin: 23px;
 		border: 1px solid #000;
  		border-radius: 20px;
  		overflow: hidden;
  		display: flex;
  		flex-direction: column;
	}
	
	div.image {
 		 width: 100%;
 		 height: 70%;
 		 cursor: pointer;
 		 background-color: #ffffff;
	}

	div.separator {
  		border-top: 1px solid #000;
	}

	div.text {
  		width: 100%;
  		height: 45%;
  		padding: 10px;
  		cursor: pointer;
  		list-style-type: none;
  		margin: 0;
  		padding-left: 0;
  		display: flex;
 		 flex-direction: column;
  		justify-content: center;
  		background-color: #ffffff;
	}

	div.text li {
 		margin-bottom: 5px;
  		overflow: hidden;
  		white-space: nowrap;
  		text-overflow: ellipsis;
	}
</style>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<jsp:include page="nav.jsp">
	<jsp:param name="menu" value="home"/>
</jsp:include>

<div class="content">
	<div class="row">
		<div class="col-6">
			<div class="smallnotice">
		<p class="fs-3">공지사항</p> <!-- fs-3  p-->
	</div>		

<div class="smallnotice ">
	<div class="row mb-3">
		<div class="col-10">
			<p class="border bg-light fs-4 p-2">공지사항</p>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-10">
			<table class="table table-sm">
				<colgroup>
					<col width="10%">
					<col width="60%">
					<col width="20%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>글쓴이</th>
						<th>제목</th>
						<th>등록일</th>
						<th>조회수</th>
					</tr>
				</thead>
				<tbody>
<%
	for(Board board: adminNoticeList){
%>
	<tr>
		<td><%=board.getUser().getNickname() %></td>
		<td><a href="notice/detail.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></td>
		<td><%=board.getCreateDate() %></td>
		<td><%=board.getReadCnt() %></td>
	</tr>
<% 
	}
%>		
						</tbody>
					</table>
				</div>
			</div>
		<div class="row mb-3">
		<div class="col-10">
			<p class="border bg-light fs-4 p-3" st></p>
		</div>
	</div>
			</div><!-- class="smallnotice" 닫김 -->
		<div class="text-end">
  			<a href="notice/list.jsp" class="btn btn-primary btn-sm ">더보기</a>
		</div>
	</div>	<!-- col1-6 닫김 -->	
		
<!-- 카테고리, 이름, 현재인원, 설명  로그인한사람들한테 보이는 파티가입 리스트-->
<div class="col-4">
	<div class="smallpartylist my-3">
		<div class="row mb-3">
			<div class="col-14">
				<P class="border bg-light fs-4 p-2">파티 가입리스트</P>
			</div>
		</div>
	<div class="row mb-3">
		<div class="col-12">
			<table class="table table-sm">
				<colgroup>
					<col width="15%">
					<col width="55%">
					<col width="20%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>카테고리</th>
						<th>파티이름</th>
						<th>현재인원</th>
						<th>설명</th>
					</tr>
				</thead>
				<tbody>
<%
		if (loginId == null) {
			
		}else{
			
%>
<tr>
		<td>1</td>
		<td>2</td>
		<td>3</td>
		<td>4</td>
</tr>
<tr>
		<td>1</td>
		<td>2</td>
		<td>3</td>
		<td>4</td>
</tr>
<tr>
		<td>1</td>
		<td>2</td>
		<td>3</td>
		<td>4</td>
</tr>
	</tbody>
<% 
		}
%>		
	</table>
		</div>
			<div class="col-14">
				<p class="border bg-light fs-4 p-3"></p>
			<div class="text-end">
			<%	if (loginId == null) { %>
  				<a href="" class="btn btn-primary btn-sm" onclick="alert('로그인 해주세요.'); return false;">더보기</a>
			<%}else { %>
				<a href="party/list.jsp" class="btn btn-primary btn-sm" >더보기</a>
			<%}%>			
			</div>
		
		</div>
			</div>
		</div> 
	</div> <!-- col-6 닫김 -->
</div>	<!-- row 닫김 -->
	
<!-- 최근 순으로 파티를 추천하는 파트 -->
<div class="background">	
<div class="box-container">
  <div class="box">
    <div class="image" onclick="window.location.href='party/list.jsp';">
      <!-- 이미지 태그 또는 배경 이미지 설정 -->
    </div>
    <div class="separator"></div>
    <div class="text" onclick="window.location.href='party/list.jsp';">
      <ul>
        <li>밴드 이름 1</li>
        <li>멤버 수 </li>
      </ul>
    </div>
  </div>
  
  <div class="box">
    <div class="image" onclick="window.location.href='party/list.jsp';">
    </div>
    <div class="separator"></div>
    <div class="text" onclick="window.location.href='party/list.jsp';">
      <ul>
        <li>밴드 이름 2</li>
        <li>멤버 수 </li>
      </ul>
    </div>
  </div>
  
  <div class="box">
    <div class="image" onclick="window.location.href='party/list.jsp';">
    </div>
    <div class="separator"></div>
    <div class="text" onclick="window.location.href='party/list.jsp';">
      <ul>
        <li>밴드 이름 3</li>
        <li>멤버 수 </li>
      </ul>
    </div>
  </div>
  
  <div class="box">
    <div class="image" onclick="window.location.href='party/list.jsp';">
    </div>
    <div class="separator"></div>
    <div class="text" onclick="window.location.href='party/list.jsp';">
      <ul>
        <li>밴드 이름 4</li>
        <li>멤버 수 </li>
      </ul>
    </div>
  </div>
  
  <div class="box">
    <div class="image" onclick="window.location.href='party/list.jsp';">
    </div>
    <div class="separator"></div>
    <div class="text" onclick="window.location.href='party/list.jsp';">
      <ul>
        <li>밴드 이름 5</li>
        <li>멤버 수 </li>
      </ul>
    </div>
  </div>

</div> <!-- 박스 컨테이너 닫김 -->
</div> <!--  background 닫김 -->
</div>	<!-- content 닫김 -->
</body>
</html>