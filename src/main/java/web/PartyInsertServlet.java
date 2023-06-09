package web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import org.apache.tomcat.util.http.fileupload.IOUtils;

import dao.PartyDao;
import dao.PartyReqDao;
import dao.UserPartyAccessDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vo.Category;
import vo.Party;
import vo.PartyAccess;
import vo.PartyReq;
import vo.User;

@WebServlet(urlPatterns = "/party/insert")
@MultipartConfig(
		fileSizeThreshold = 1024*1024*1,
		maxFileSize = 1024*1024*5,
		maxRequestSize = 1024*1024*10)
public class PartyInsertServlet extends HttpServlet {
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		// 세션에서 로그인 아이디 조회하기
		HttpSession session = req.getSession(false);
		String loginId = (String) session.getAttribute("loginId");
		loginId = "ryu";
		if (loginId == null) {
			res.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("파티 개설", "utf-8"));
			return;
		}
		// 요청 파라미터 조회
		// 일반 입력필드의 값 조회
		int catNo = Integer.parseInt(req.getParameter("partyCat"));
		String name = req.getParameter("partyName");
		int quota = Integer.parseInt(req.getParameter("partyQuota"));
		String description = req.getParameter("partyDescription");
		String reqName = req.getParameter("reqName");
		String reqValue = req.getParameter("reqValue");
		String reqDescription = req.getParameter("reqDescription");
		// 파티번호 값 조회 및 저장
		PartyDao partyDao = PartyDao.getInstance();
		int partyNo = partyDao.getPartySeq();
		// 첨부파일 입력필드의 처리
		Part upfilePart = req.getPart("partyImage");
		
		String filename = null;
		if (!upfilePart.getSubmittedFileName().isEmpty()) {
			int length = upfilePart.getSubmittedFileName().length();
			filename = System.currentTimeMillis() + upfilePart.getSubmittedFileName().substring(Math.max(0,length-5));
			// 업로드된 첨부파일을 지정된 폴더에 저장
			InputStream in = upfilePart.getInputStream();
			OutputStream out = new FileOutputStream(new File("/Users/seung-gyu/workspace/web-workspace/party/src/main/webapp/resources/thumbnail", filename));
			IOUtils.copy(in, out);
		}
		
		// 업무로직 수행
		// 파티 저장
		Party party = new Party();
		party.setNo(partyNo);
		party.setCategory(new Category(catNo));
		party.setName(name);
		party.setManager(new User(loginId));
		party.setQuota(quota);
		party.setDescription(description);
		party.setFilename(filename);
		
		// 유저 파티접근권 저장
		PartyAccess partyAccess = new PartyAccess();
		partyAccess.setAuthNo(6);
		partyAccess.setParty(new Party(partyNo));
		partyAccess.setUser(new User(loginId));
		partyAccess.setDescription(party.getName() + "파티 운영자");
		
		// 파티 제한 저장
		// 조건이 있는 경우에만 저장을 한다.
		if (!reqName.isBlank() && !reqValue.isBlank()) {
			PartyReq partyReq = new PartyReq();
			partyReq.setParty(new Party(partyNo));
			partyReq.setName(reqName);
			partyReq.setValue(reqValue);
			partyReq.setDescription(reqDescription);
			// 객체 생성후 db에 저장
			PartyReqDao partyReqDao = PartyReqDao.getInstance();
			partyReqDao.insertPartReq(partyReq);
		}
		// 데이터베이스에 저장
		UserPartyAccessDao userPartyAccessDao = UserPartyAccessDao.getInstance();
		// 파티명이 동일한지 유효성 검사 진행
		Party savedParty = partyDao.getPartyByName(name);
		if (savedParty != null ) {
			if (savedParty.getCategory().getNo() == catNo) {
				if (name.equals(savedParty.getName())) {
					res.sendRedirect("create-form.jsp?err=name");
					return;
				}
			}
		}
		partyDao.insertParty(party);			
		// 
		userPartyAccessDao.insertUserPartyAccess(partyAccess);
		
		// 재요청 URL 전송(파티 홈으로 갈 것)
		res.sendRedirect("../home.jsp");
	}
}
