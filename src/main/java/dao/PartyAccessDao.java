package dao;

import util.DaoHelper;
import vo.Party;
import vo.PartyAccess;
import vo.User;

public class PartyAccessDao {
	
	private static PartyAccessDao instance = new PartyAccessDao();
	private PartyAccessDao() {}
	public static PartyAccessDao getInstance() {
		return instance;
	}
	
	public void insertPartyAccess(PartyAccess partyAccess) {
		DaoHelper.update("partyAccessDao.insertPartyAccess",
				partyAccess.getUser().getId(),
				partyAccess.getParty().getNo(),
				partyAccess.getAuthNo(),
				partyAccess.getDescription());
	}
	
	public Integer getAuthNoByPartyNoAndUserId(int partyNo, String userId) {
		return DaoHelper.selectOne("partyAccessDao.getAuthNoByPartyNoAndUserId", rs -> {
			return rs.getInt("auth_no");
		}, partyNo, userId);
	}
	
	public PartyAccess getPartyAccessByPartyNoAndUserId(int no, String id) {
		return DaoHelper.selectOne("partyAccessDao.getPartyAccessByPartyNoAndUserId", rs -> {
			PartyAccess partyAccess = new PartyAccess();
			partyAccess.setNo(rs.getInt("access_no"));
			partyAccess.setUser(new User(id));
			partyAccess.setParty(new Party(no));
			partyAccess.setAuthNo(rs.getInt("auth_no"));
			partyAccess.setCreateDate(rs.getDate("access_create_date"));
			partyAccess.setDescription(rs.getString("access_description"));
			return partyAccess;
		}, no, id);
	}
	
	public void updatePartyAccess(PartyAccess partyAccess) {
		DaoHelper.update("partyAccessDao.updatePartyAccess",
				partyAccess.getAuthNo(),
				partyAccess.getDescription(),
				partyAccess.getAuthNo());
	}
}
