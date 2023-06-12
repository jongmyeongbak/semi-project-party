package dao;

import util.DaoHelper;
import vo.PartyAccess;

public class UserPartyAccessDao {
	
	private static UserPartyAccessDao instance = new UserPartyAccessDao();
	private UserPartyAccessDao() {}
	public static UserPartyAccessDao getInstance() {
		return instance;
	}
	
	public void insertUserPartyAccess(PartyAccess partyAccess) {
		DaoHelper.update("userPartyAccessDao.insertUserPartyAccess",
				partyAccess.getUser().getId(),
				partyAccess.getParty().getNo(),
				partyAccess.getAuthNo(),
				partyAccess.getDescription());
	}
}
