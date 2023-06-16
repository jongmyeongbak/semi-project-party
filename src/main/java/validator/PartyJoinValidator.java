package validator;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

import dao.PartyDao;
import dao.PartyReqDao;
import dao.UserDao;
import vo.Party;
import vo.User;

public class PartyJoinValidator {
	
	private PartyJoinValidator() {
	}
	
	public static int getQuotawhenExceed(int partyNo) {
		Party party = PartyDao.getInstance().getPartyByNo(partyNo);
		if (party.getCurCnt() < party.getQuota()) {
			return party.getQuota();
		}
		return -1;
	}

	public static String getPartyReqWhenNotFit(int partyNo, String loginId) {
		List<String> partyReqs = PartyReqDao.getInstance().getValuesByNo(partyNo);
		User user = UserDao.getInstance().getUserById(loginId);
		
		LocalDate localdate = user.getBirthdate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
		int userBornYear = localdate.getYear();
		int reqBirth1 = Integer.parseInt(partyReqs.get(0));
		int reqBirth2 = Integer.parseInt(partyReqs.get(1));
		
		String userGender = user.getGender();
		String reqGender = partyReqs.get(2);
		
		if (reqBirth1 >= userBornYear && userBornYear >= reqBirth2 && (reqGender.equals("A") || reqGender.equals(userGender))) {
			return null;
		}
		
		StringBuilder sb = new StringBuilder(35);
		sb.append("조건에 맞지 않습니다.\n가입 조건: ");
		if (reqBirth1 == reqBirth2) {
			sb.append(reqBirth1);
		} else {
			sb.append(reqBirth2).append("~").append(reqBirth1);
		}
		sb.append("년생");
		if (reqGender.equals("M")) {
			sb.append(" 남자");
		} else if (reqGender.equals("F")) {
			sb.append(" 여자");
		}
		return sb.toString();
	}
}
