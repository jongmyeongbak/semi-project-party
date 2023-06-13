package dao;

import util.DaoHelper;
import vo.UserPartyAccess;

public class UserPartyAccessDao {
	
	private static UserPartyAccessDao instance = new UserPartyAccessDao();
	private UserPartyAccessDao() {}
	public static UserPartyAccessDao getInstance() {
		return instance;
	}
	
	public void insertUserPartyAccess(UserPartyAccess userPartyAccess) {
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
