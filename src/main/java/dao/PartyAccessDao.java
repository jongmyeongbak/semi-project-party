package dao;

import util.DaoHelper;
import vo.PartyAccess;

public class PartyAccessDao {
	
	private static PartyAccessDao instance = new PartyAccessDao();
	private PartyAccessDao() {}
	public static PartyAccessDao getInstance() {
		return instance;
	}
	
	public void insertUserPartyAccess(PartyAccess userPartyAccess) {
		DaoHelper.update("userPartyAccessDao.insertUserPartyAccess",
				userPartyAccess.getUser().getId(),
				userPartyAccess.getParty().getNo(),
				userPartyAccess.getAuthNo(),
				userPartyAccess.getDescription());
	}
	
	public int getAuthNoByIdName(String loginId, int no) {
		return DaoHelper.selectOne("userPartyAccessDao.getAuthNoByIdName", rs -> {
			return rs.getInt("auth_no");
		}, loginId, no);
	}
}
