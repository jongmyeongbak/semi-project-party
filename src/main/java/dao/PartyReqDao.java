package dao;

import util.DaoHelper;
import vo.PartyReq;

public class PartyReqDao {
	
	private static PartyReqDao instance = new PartyReqDao();
	private PartyReqDao() {}
	public static PartyReqDao getInstance() {
		return instance;
	}
	
	public void insertPartReq(PartyReq partyReq) {
		DaoHelper.update("partyReqDao.insertPartyReq",
				partyReq.getParty().getNo(),
				partyReq.getName(),
				partyReq.getValue(),
				partyReq.getDescription());
	}
}
