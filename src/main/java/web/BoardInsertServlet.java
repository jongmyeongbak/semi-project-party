package web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import org.apache.tomcat.util.http.fileupload.IOUtils;

import dao.BoardDao;
import dao.PartyAccessDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import util.StringUtils;
import vo.Board;
import vo.Party;
import vo.User;

@WebServlet(urlPatterns = "/party/board/insert")
@MultipartConfig(
		fileSizeThreshold = 1024*1024*1,
		maxFileSize = 1024*1024*5,
		maxRequestSize = 1024*1024*10)
public class BoardInsertServlet extends HttpServlet {
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 세션에서 로그인 아이디 조회
		HttpSession session = req.getSession(false);
		String loginId = (String) session.getAttribute("loginId");
		int partyNo = StringUtils.stringToInt(req.getParameter("partyNo"));
		
		// 로그인 상태가 아닌 경우 로그인 폼으로 리디렉트
		if (loginId == null) {
			resp.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("게시물 작성", "utf-8"));
			return;
		}
		
		// 유효성 검사
		// 게시글 작성을 시도하는 유저가 파티 접근권을 가지고 있는지, 강퇴나 탈퇴 상태인지 확인
		PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
		Integer authNo = partyAccessDao.getAuthNoByPartyNoAndUserId(partyNo, loginId);
		
		if (authNo == null) {
			resp.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("게시글 작성", "UTF-8"));
			return;
		}
		
		// 요청 파라미터 조회
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		
		
		// 첨부파일 처리
		Part upfilePart = req.getPart("boardImage");
		String filename = null;
		if (!upfilePart.getSubmittedFileName().isEmpty()) {
			int length = upfilePart.getSubmittedFileName().length();
			filename = System.currentTimeMillis() + upfilePart.getSubmittedFileName().substring(Math.max(0,length-5));
			// 업로드된 첨부파일을 지정된 폴더에 저장
			String uploadPath = System.getenv("PROJECT_IMAGE") + "/board";
			InputStream in = upfilePart.getInputStream();
			OutputStream out = new FileOutputStream(new File(uploadPath, filename));
			IOUtils.copy(in, out);
			in.close();
			out.close();
		}
		
		//업무로직 수행
		Board board = new Board();
		board.setUser(new User(loginId));
		board.setParty(new Party(partyNo));
		board.setTitle(title);
		board.setContent(content);
		board.setFilename(filename);
		
		// 데이터 베이스에 게시글 추가
		BoardDao boardDao = BoardDao.getInstance();
		boardDao.insertBoard(board);
		
		resp.sendRedirect("home.jsp?no=" + partyNo);
		
		
	}

}
