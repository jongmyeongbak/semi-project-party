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
import util.StringUtils;
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
		if (loginId == null) {
			res.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("파티 개설", "utf-8"));
			return;
		}
		// 요청 파라미터 조회
		
		// 일반 입력필드의 값 조회
		int catNo = StringUtils.stringToInt(req.getParameter("partyCat"));
		if (catNo == 0) {
			res.sendRedirect("form.jsp?err=cat");
			return;
		}
		String name = req.getParameter("partyName");
		int quota = Integer.parseInt(req.getParameter("partyQuota"));
		String description = req.getParameter("partyDescription");
		// 파티 가입 제한 값 조회
		String reqAge = req.getParameter("reqAge");
		String birthStart = req.getParameter("birthStart");
		String birthEnd = req.getParameter("birthEnd");
		String reqGen = req.getParameter("reqGen");
		String gender = req.getParameter("gender");
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
		// 파티 객체 생성
		Party party = new Party();
		party.setNo(partyNo);
		party.setCategory(new Category(catNo));
		party.setName(name);
		party.setManager(new User(loginId));
		party.setQuota(quota);
		party.setDescription(description);
		party.setFilename(filename);
		
		// 유저 파티접근권 객체 생성
		PartyAccess partyAccess = new PartyAccess();
		partyAccess.setAuthNo(6);
		partyAccess.setParty(new Party(partyNo));
		partyAccess.setUser(new User(loginId));
		partyAccess.setDescription(party.getName() + "파티 운영자");
		
		// 데이터베이스에 저장
		// 파티명이 동일한지 유효성 검사 진행
		Party savedParty = partyDao.getPartyByName(name);
		if (savedParty != null ) {
			if (savedParty.getCategory().getNo() == catNo) {
				if (name.equals(savedParty.getName())) {
					res.sendRedirect("form.jsp?err=name");
					return;
				}
			}
		}
		partyDao.insertParty(party);			
		UserPartyAccessDao userPartyAccessDao = UserPartyAccessDao.getInstance();
		userPartyAccessDao.insertUserPartyAccess(partyAccess);
		
		// 파티 제한 객체 생성 (파티가 저장되어야 무결성 위배원칙에 어긋나지 않아서 파티 저장 이후에 실행)
		// 조건이 있는 경우에만 생성을 한다.
		// 나이제한
		if (reqAge != null) {
			PartyReqDao partyReqDao = PartyReqDao.getInstance();
			// 시작년도 객체 생성(있다면)
			if (!birthStart.isBlank()) {
				PartyReq partyReq1 = new PartyReq();
				partyReq1.setParty(new Party(partyNo));
				partyReq1.setName("생년1");
				partyReq1.setValue(birthStart);				
				// 데이터베이스에 저장
				partyReqDao.insertPartyReq(partyReq1);
			}
			// 끝년도 객체 생성(있다면)
			if (!birthEnd.isBlank()) {
				PartyReq partyReq2 = new PartyReq();
				partyReq2.setParty(new Party(partyNo));
				partyReq2.setName("생년2");
				partyReq2.setValue(birthEnd);
				// 데이터베이스에 저장
				partyReqDao.insertPartyReq(partyReq2);
			}
		}
		// 성별제한(있다면)
		if (reqGen != null) {
			PartyReqDao partyReqDao = PartyReqDao.getInstance();
			PartyReq partyReqGen = new PartyReq();
			partyReqGen.setParty(new Party(partyNo));
			partyReqGen.setName("성별");
			partyReqGen.setValue(gender);
			// 데이터베이스에 저장
			partyReqDao.insertPartyReq(partyReqGen);
		}
		
		// 재요청 URL 전송(파티 홈으로 갈 것)
		res.sendRedirect("home.jsp?no" + partyNo);
	}
}
