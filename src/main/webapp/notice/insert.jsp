<%@page import="java.time.ZoneId"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="vo.User"%>
<%@page import="vo.Board"%>
<%@page import="dao.AdminNoticeDao"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
//세션에서 로그인된 권한 및 고객아이디 조회하기
Integer auth = (Integer) session.getAttribute("auth");
if (auth == null || auth > 3) {
	response.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("새글등록", "utf-8"));
	return;
}
String loginId = (String) session.getAttribute("loginId");

//일반 입력필드 조회
String title = request.getParameter("title");
String content = request.getParameter("content");
if ("".equals(title) || "".equals(content) || title == null || content == null) { // "": normal case, null: abnormal case
	response.sendRedirect("form.jsp?err=empty");
	return;
}

AdminNoticeDao adminNotiDao = AdminNoticeDao.getInstance();
int no = adminNotiDao.getNoticesSeq();
Board board = new Board(no);
board.setTitle(title);
board.setContent(content);
board.setUser(new User(loginId));

if ("true".equals(request.getParameter("now"))) {
	adminNotiDao.insertNotice(board);
} else {
	LocalDateTime dateTime = LocalDateTime.of(
			LocalDate.parse(request.getParameter("date")),
			LocalTime.parse(request.getParameter("time")));
	Date utilDate = Date.from(dateTime.atZone(ZoneId.systemDefault()).toInstant());
	adminNotiDao.insertNotice(board, utilDate);
}

response.sendRedirect("detail.jsp?no=" + no);
%>