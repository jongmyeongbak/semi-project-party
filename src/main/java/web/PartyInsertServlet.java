
package web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import org.apache.tomcat.util.http.fileupload.IOUtils;

import dao.PartyAccessDao;
import dao.PartyDao;
import dao.PartyReqDao;
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
		String name = req.getParameter("partyName");
		int quota = StringUtils.stringToInt(req.getParameter("partyQuota"));
		String description = req.getParameter("partyDescription");
		String birthStart = req.getParameter("birthStart");
		String birthEnd = req.getParameter("birthEnd");
		String gender = req.getParameter("gender");
		
		// 유효성 검사
		// 카테고리가 선택되어 있지 않을 때
		if (catNo == 0) {
			res.sendRedirect("form.jsp?err=cat");
			return;
		}
		// 동일한 파티명이 존재할 때
		PartyDao partyDao = PartyDao.getInstance();
		Party savedParty = partyDao.getPartyByName(name);
		if (savedParty != null && savedParty.getName().equals(name)) {
			res.sendRedirect("form.jsp?err=name");
			return;
		}
		// 최소나이가 최대 나이보다 값이 작을 때
		// 값이 String이기 때문에 int로 변환해서 크기 비교를 진행한다.
		if (StringUtils.stringToInt(birthStart) < StringUtils.stringToInt(birthEnd)) {
			res.sendRedirect("form.jsp?err=birth");
			return;
		}
		
		// 첨부파일 입력필드의 처리
		Part upfilePart = req.getPart("partyImage");
		String filename = null;
		if (!upfilePart.getSubmittedFileName().isEmpty()) {
			int length = upfilePart.getSubmittedFileName().length();
			filename = System.currentTimeMillis() + upfilePart.getSubmittedFileName().substring(Math.max(0,length-5));
			// 업로드된 첨부파일을 지정된 폴더에 저장
			String uploadPath = System.getenv("PROJECT_IMAGE") + "/thumbnail";
			InputStream in = upfilePart.getInputStream();
			OutputStream out = new FileOutputStream(new File(uploadPath, filename));
			IOUtils.copy(in, out);
			in.close();
			out.close();
		}
		
		// 업무로직 수행
		// 파티 번호 생성
		int partyNo = partyDao.getPartySeq();
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
		
		// 파티 제한 객체 생성
		PartyReq partyReq1 = new PartyReq();
		partyReq1.setParty(new Party(partyNo));
		partyReq1.setName("생년1");
		partyReq1.setValue(birthStart);
		PartyReq partyReq2 = new PartyReq();
		partyReq2.setParty(new Party(partyNo));
		partyReq2.setName("생년2");
		partyReq2.setValue(birthEnd);
		PartyReq partyReq3 = new PartyReq();
		partyReq3.setParty(new Party(partyNo));
		partyReq3.setName("성별");
		partyReq3.setValue(gender);
		
		// 데이터베이스에 저장
		PartyReqDao partyReqDao = PartyReqDao.getInstance();
		PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
		// 파티 저장
		partyDao.insertParty(party);			
		// 유저의 파티 접근권 저장
		partyAccessDao.insertPartyAccess(partyAccess);
		// 파티 가입조건 저장
		partyReqDao.insertPartyReq(partyReq1, partyReq2, partyReq3);
		
		// 재요청 URL 전송(파티 홈으로 갈 것)
		res.sendRedirect("home.jsp?no=" + partyNo);
	}
}
