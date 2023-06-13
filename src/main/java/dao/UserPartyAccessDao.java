package dao;

import util.DaoHelper;
import vo.Party;
import vo.PartyAccess;
import vo.User;

public class UserPartyAccessDao {
	
	private static UserPartyAccessDao instance = new UserPartyAccessDao();
	private UserPartyAccessDao() {}
	public static UserPartyAccessDao getInstance() {
		return instance;
	}
	
	public PartyAccess getUserPartyAccessByPartyNoUserId(int partyNo, String loginId) {
		return DaoHelper.selectOne("userPartyAccessDao.getUserPartyAccessByPartyNoUserId", rs -> {
			PartyAccess partyAccess = new PartyAccess();
			partyAccess.setUser(new User(rs.getString("user_id")));
			partyAccess.setParty(new Party(rs.getInt("party_no")));
			partyAccess.setAuthNo(rs.getInt("auth_no"));
			
			return partyAccess;
		}, partyNo, loginId);
	}
	
	public void insertUserPartyAccess(PartyAccess partyAccess) {
		DaoHelper.update("userPartyAccessDao.insertUserPartyAccess",
				partyAccess.getUser().getId(),
				partyAccess.getParty().getNo(),
				partyAccess.getAuthNo(),
				partyAccess.getDescription());
	}
}
