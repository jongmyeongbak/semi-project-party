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
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import util.StringUtils;
import vo.Party;
import vo.PartyReq;

@WebServlet(urlPatterns = "/party/modify")
@MultipartConfig(
		fileSizeThreshold = 1024*1024*1,
		maxFileSize = 1024*1024*5,
		maxRequestSize = 1024*1024*10)
public class PartyModifyServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		// 세션에서 로그인 아이디 조회하기
		HttpSession session = req.getSession(false);
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			res.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("파티 수정", "utf-8"));
			return;
		}
		
		// 요청 파라미터 조회
		// 일반 입력필드의 값 조회
		int no = StringUtils.stringToInt( req.getParameter("no"));
		String name = req.getParameter("partyName");
		int quota = StringUtils.stringToInt(req.getParameter("partyQuota"));
		String description = req.getParameter("partyDescription");
		// 파티 가입 제한 값 조회
		String reqAge = req.getParameter("reqAge");
		String birthStart = req.getParameter("birthStart");
		String birthEnd = req.getParameter("birthEnd");
		String reqGen = req.getParameter("reqGen");
		String gender = req.getParameter("gender");
		
		// 업무로직 수행
		PartyDao partyDao = PartyDao.getInstance();
		// 파티 no로 저장된 파티객체 불러오기
		Party savedParty = partyDao.getPartyByNo(no);
		// 수정 가능한 항목들 setter로 바꾸기
		
		// 유효성 검사
		// 파티명이 동일한지 유효성 검사 진행 (이름만 검사)
		Party nameParty = partyDao.getPartyByName(name);
		// 기존 파티명과 같은건 상관 없으나, 다른 파티의 이름과 중복되면 안됨
		if (!savedParty.getName().equals(name) && nameParty != null) {
			res.sendRedirect("modify-form.jsp?no="+no+"&err=name");
			return;
		}
		// 최소나이가 최대 나이보다 값이 작을 때
		// 값이 String이기 때문에 int로 변환해서 크기 비교를 진행한다.
		if (StringUtils.stringToInt(birthStart) < StringUtils.stringToInt(birthEnd)) {
			res.sendRedirect("modify-form.jsp?err=birth");
			return;
		}
		
		// 변경사항 기존 객체에 저장
		savedParty.setName(name);
		savedParty.setQuota(quota);
		savedParty.setDescription(description);
		// 첨부파일 값 불러오고 저장
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
		savedParty.setFilename(filename);
		// 수정된 파티 객체를 데이터베이스에 업데이트 하기
		partyDao.updateParty(savedParty);
		
		// 파티 no로 저장된 파티 가입조건 삭제
		PartyReqDao partyReqDao = PartyReqDao.getInstance();
		partyReqDao.deletePartyReqByNo(no);
		// 파티 제한 객체 생성
		PartyReq partyReq1 = new PartyReq();
		partyReq1.setParty(new Party(no));
		partyReq1.setName("생년1");
		partyReq1.setValue(birthStart);
		PartyReq partyReq2 = new PartyReq();
		partyReq2.setParty(new Party(no));
		partyReq2.setName("생년2");
		partyReq2.setValue(birthEnd);
		PartyReq partyReq3 = new PartyReq();
		partyReq3.setParty(new Party(no));
		partyReq3.setName("성별");
		partyReq3.setValue(gender);
		// 파티 제한 객체 저장
		partyReqDao.insertPartyReq(partyReq1, partyReq2, partyReq3);
		
		// 재요청 URL 전송(파티 홈으로 갈 것)
		res.sendRedirect("board/home.jsp?no=" + no);
	}
}
