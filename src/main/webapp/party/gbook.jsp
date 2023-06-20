<%@page import="info.Pagination"%>
<%@page import="dao.PartyAccessDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="dao.GuestBookDao"%>
<%@page import="vo.User"%>
<%@page import="util.StringUtils"%>
<%@page import="util.DateUtils"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.Party"%>
<%@page import="vo.GuestBook"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	//로그인 로직
	String loginId = (String) session.getAttribute("loginId");
	Integer errPage = (Integer) session.getAttribute("page");
	
	if (loginId == null) {
	    out.println("<script>alert('로그인이 필요합니다.');</script>");
	    out.println("<script>history.back();</script>");
	    return; 
	}
	
	//파티를 식별할 partyNo 값 
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	//파티번호로 방명록조회
	GuestBookDao gusetBookDao = GuestBookDao.getInstance();
	List<GuestBook> gusetbookList = gusetBookDao.getGuestBooksByPartyNo(partyNo);
	
	//권한가져오기 (파티와 가입번호를 받아서 유저 권한 조회)
	PartyAccessDao partyaccessdao = PartyAccessDao.getInstance();
	Integer authNo = partyaccessdao.getAuthNoByPartyNoAndUserId(partyNo, loginId);
	
	if (authNo == null || authNo.equals(8) || authNo.equals(9)) {
	    out.println("<script>alert('파티의 멤버만 접근가능합니다.');</script>");
	    out.println("<script>history.back();</script>");
	    return; 
	} 
	
	//페이지네이션
	int pageNo = StringUtils.stringToInt(request.getParameter("page"), 1);
	int totalRows = gusetBookDao.getTotalRowsByPartyNo(partyNo);
	Pagination pagination = new Pagination(pageNo, totalRows);
	List<GuestBook> guestBooks = gusetBookDao.getGuestBooksByPartyNoPage(partyNo, pagination.getFirstRow(), pagination.getLastRow());
	
	//유효하지 않은 페이지번호 검사
	if (pageNo < 1 || pageNo > pagination.getTotalPages()) {
	    out.println("<script>alert('유효하지 않은 페이지 번호입니다.'); history.back();</script>");
	    return;
	}
	
	//현재 로그인한 유저닉네임 가져오는데 쓰임
	UserDao userdao = UserDao.getInstance();
	User user = userdao.getUserById(loginId);
	
	//create_date를 가져오는 것
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!doctype html>
<html lang="ko">
<head>
<title>파티방명록입니다.</title>
<link rel="stylesheet" href="css/partygbook.css"/>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<div class="container">
<jsp:include page="../nav.jsp">
	<jsp:param name="pmenu" value="gbook"/>
</jsp:include>
</div>

<div class="container">
<div class="title fs-4 p-3 " style="margin-top:20px; text-align:center;" >방명록</div>

<div class="mb-1">

	<div class="background">
			<b>[<%=user.getNickname() %>]님 환영합니다. </b>
		</div>
		<form class="border bg-light p-3 " method="post" action="gbook-insert.jsp">
		<input type="hidden" name="partyNo" value="<%=partyNo%>"/>
			<div class="row">
				<div class="col-11">
					<textarea rows="6" class="form-control col-11" name="content" placeholder="따뜻한 인사말을 건네보세요. (최대 500자.)"></textarea>
				</div>
			<div class="col-1">
					<button class="btn btn-outline-primary h-100 w-100"onclick="return confirm('방명록을 등록하시겠습니까?')">등록</button>
				</div>
			</div>
		</form>
	</div>
			<div style="border-top: 17px solid rgb(194, 225, 255);"></div>
	<div calss="mb-3">
	
		<% for(GuestBook guestBook: guestBooks){ %>
		<div class="background">
			<b>[<%=guestBook.getUser().getNickname()%>]님의 방명록</b>
			<p><%=dateFormat.format(guestBook.getCreateDate())%></p>
		</div>
		<form class="border bg-light p-3" method="post" action="gbook-delete.jsp">
		<input type="hidden" name="gbNo" value="<%=guestBook.getNo()%>"/>
		<input type="hidden" name="partyNo" value="<%=partyNo%>"/>
			<div class="row">
				<div class="col-11">
					<div class="text text-break fs-5" name="content" style="background-color: rgb(255,255,255); padding: 20px; border-radius: 10px; white-space: break-spaces;">
					 <%=guestBook.getContent() %></div >
				</div>
				<div class="col-1">
					<%
				String guestBookLoginId = guestBook.getUser().getId();
					if ((loginId != null && loginId.equals(guestBookLoginId)) || authNo.equals(6)) { %>
					<button class="btn btn-outline-danger h-100 w-100" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</button>
				<%
				} else {
				%>
					<button class="btn btn-outline-danger h-100 w-100" disabled>삭제</button>
				<%
				}
				%>
				</div>
			</div>
		</form>
		<div class="title fs-4 p-2" ></div>
	<%}%>

</div><!-- mb3 닫김 -->
		<div class="border bg-light p-3" style="margin-top: -23px;"></div>
	<div class="title fs-4 p-4" style="margin-top: -30px;"></div>	
<%
	String baseUrl = "gbook.jsp?no=" + partyNo; // 기본 URL 주소에 파티 번호를 추가
%>	
	<div>
			<ul class="pagination justify-content-center pagination-lg" style="margin-top: 10px">
			<li class="page-item<%=pageNo <= 1 ? " disabled" : "" %>">
				<a class="page-link" href="<%=baseUrl + "&page=" + (pageNo - 1) %>">이전</a>
			</li>
				<%
					int lastPageNo = pagination.getLastPageNoOnPageList();
					for (int no = pagination.getFirstPageNoOnPageList(); no <= lastPageNo; no++) {
				%>
			<li class="page-item<%=no == pageNo ? " active" : "" %>">
				 <a class="page-link" href="<%=baseUrl + "&page=" + no %>"><%=no %></a>
			</li>
				<%
					}
				%>
			<li class="page-item<%=pageNo >= pagination.getTotalPages() ? " disabled" : "" %>">
				<a class="page-link" href="<%=baseUrl + "&page=" + (pageNo + 1) %>">다음</a>
			</li>
				</ul>
			</div>
</div><!--container닫김-->
</body>
</html>