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
		DaoHelper.update("partyAccessDao.insertUserPartyAccess",
				userPartyAccess.getUser().getId(),
				userPartyAccess.getParty().getNo(),
				userPartyAccess.getAuthNo(),
				userPartyAccess.getDescription());
	}
	
	public Integer getAuthNoByPartyNoAndUserId(int partyNo, String userId) {
		return DaoHelper.selectOne("partyAccessDao.getAuthNoByPartyNoAndUserId", rs -> {
			return rs.getInt("auth_no");
		}, partyNo, userId);
	}
}
