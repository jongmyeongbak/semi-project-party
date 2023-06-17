package web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import org.apache.tomcat.util.http.fileupload.IOUtils;

import dao.BoardDao;
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

@WebServlet(urlPatterns = "/party/board/modify")
@MultipartConfig(
		fileSizeThreshold = 1024*1024*1,
		maxFileSize = 1024*1024*5,
		maxRequestSize = 1024*1024*10)
public class BoardModifyServlet extends HttpServlet {
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 세션에서 로그인 아이디 조회
		HttpSession session = req.getSession(false);
		String loginId = (String) session.getAttribute("loginId");
		
		// 로그인 상태가 아닌 경우 리디렉트
		if (loginId == null) {
			resp.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("게시물 수정", "utf-8"));
			return;
		}
		
		// 변경할 요소 요청 파라미터 조회		
		int boardNo = StringUtils.stringToInt(req.getParameter("boardNo"));
		int partyNo = StringUtils.stringToInt(req.getParameter("partyNo"));
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		
		// 변경할 첨부파일 처리
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
		
		// 업무 로직 수행- 기존의 게시물을 수정폼에 입력된 내용으로 변경
		BoardDao boardDao = BoardDao.getInstance();
		Board savedBoard = boardDao.getBoardByBoardNo(boardNo);
		savedBoard.setTitle(title);
		savedBoard.setContent(content);
		savedBoard.setFilename(filename);
		
		// 변경된 사항을 데이터 베이스에 업데이트
		boardDao.updateBoard(savedBoard);
		
		resp.sendRedirect("home.jsp?no=" + partyNo);
	}
}
