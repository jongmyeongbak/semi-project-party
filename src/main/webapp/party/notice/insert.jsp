<%@page import="dao.PartyAccessDao"%>
<%@page import="vo.Party"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.User"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="vo.PartyNotice"%>
<%@page import="dao.UserAuthDao"%>
<%@page import="dao.PartyNoticeDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그인권한 확인하기
	String loginId = (String) session.getAttribute("loginId");
	Integer auth = (Integer) session.getAttribute("auth");
	int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));

//	if (auth == null || auth != 6 ) {
//		// 공지사항 목록으로 리다이렉트
//		System.out.println(auth);
//		System.out.println("여기서 안된듯");
//		return;
//	}
	
	//로그인 상태인지 확인 후 로그인 권유
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=login" + "&redirect=/party/notice/list.jsp?no=" + partyNo);
		return;
	}
	
	Integer partyAuthNo = PartyAccessDao.getInstance().getAuthNoByPartyNoAndUserId(partyNo, loginId);
	if (!(partyAuthNo != null && partyAuthNo == 6)) {
		response.sendRedirect("../board/home.jsp?no=" + partyNo);
		return;
	}
	
	// 요청 파라미터값 조회
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	// 제목과 내용을 하나라도 적지 않으면 작성 불가
	if(title.isBlank() || content.isBlank()) {
		response.sendRedirect("form.jsp?err=blank");
		return;
	}
	
	// 제출받은 게시물 저장
	PartyNoticeDao partyNoticeDao = PartyNoticeDao.getInstance();
	int no = partyNoticeDao.getPartyNoticeSeq();
	PartyNotice partyNotice = new PartyNotice();
	partyNotice.setParty(new Party(partyNo));
	partyNotice.setTitle(title);
	partyNotice.setContent(content);
	partyNotice.setUser(new User(loginId));
	
	// 게시물 등록 수행
	partyNoticeDao.insertPartyNotice(partyNotice);
	
	// 재요청 URL 응답
	response.sendRedirect("list.jsp?no=" + partyNo);
%>