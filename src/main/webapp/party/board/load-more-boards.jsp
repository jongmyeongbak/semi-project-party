<%@page import="java.util.HashMap"%>
<%@page import="dao.CommentDao"%>
<%@page import="vo.Comment"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="util.StringUtils"%>
<%@page import="info.Pagination"%>
<%@page contentType="application/json;charset=utf-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true"%>
<%
	// 요청 파라미터 값 조회
	String loginId = (String) session.getAttribute("loginId");
	int pageNum = StringUtils.stringToInt(request.getParameter("pageNum"));
	int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));
	BoardDao boardDao = BoardDao.getInstance();
	
	// 댓글 불러오기
	CommentDao commentDao = CommentDao.getInstance();
	
	// 기존의 페이지네이션 객체를 활용하여 스크롤이 끝에 다다르면 일정한 갯수의 게시판 조회
	int totalRows = boardDao.getBoardsTotalRowsByPartyNo(partyNo);
    Pagination pagination = new Pagination(pageNum, totalRows);
    
    // 보드 불러오기
    List<Board> boards = boardDao.getBoardsByPartyNo(partyNo, pagination.getFirstRow(), pagination.getLastRow());
    // 댓글 불러오기
    
    List<Map<String, Object>> boardsCommentsIsMine = new ArrayList<>();
    for (Board board : boards) {
    	Map<String, Object> boardMap = new HashMap<>();
        boardMap.put("board", board);
        boardMap.put("isMine", board.getUser().getId().equals(loginId));
        boardMap.put("comments", commentDao.getCommentsWithIsMineByBoardNo(board.getNo(), loginId));
        
        boardsCommentsIsMine.add(boardMap);
    }
    // 게시판 목록정보를 json형식으로 텍스트로 변환한다
    // 바로 json형식으로 변환해서 불러온 날짜는 형식은 mm dd, yyyy 형식이다. 
    // 이를 yyyy-mm-dd형식으로 바꾸기 위해 Gson객체를 생성할 때 변환할 날짜 형식을 지정한다.
   	Gson gson = new GsonBuilder()
				   .setDateFormat("yyyy-MM-dd")
				   .create();
    
    String text = gson.toJson(boardsCommentsIsMine);
	
    // 응답으로 json텍스트를 보낸다.
    out.write(text);
	
%>
