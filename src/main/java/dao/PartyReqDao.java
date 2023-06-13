package dao;

import java.util.List;

import util.DaoHelper;
import vo.PartyReq;

public class PartyReqDao {
	
	private static PartyReqDao instance = new PartyReqDao();
	private PartyReqDao() {}
	public static PartyReqDao getInstance() {
		return instance;
	}
	
	public void insertPartyReq(PartyReq partyReq) {
		DaoHelper.update("partyReqDao.insertPartyReq",
				partyReq.getParty().getNo(),
				partyReq.getName(),
				partyReq.getValue());
	}
	
	public void insertPartyReq(PartyReq partyReq1, PartyReq partyReq2, PartyReq partyReq3) {
		DaoHelper.update("partyReqDao.insertPartyReqTriple",
				partyReq1.getParty().getNo(),
				partyReq1.getName(),
				partyReq1.getValue(),
				partyReq2.getParty().getNo(),
				partyReq2.getName(),
				partyReq2.getValue(),
				partyReq3.getParty().getNo(),
				partyReq3.getName(),
				partyReq3.getValue());
	}
	
	public List<String> getValuesByNo(int no) {
		return DaoHelper.selectList("partyReqDao.getValuesByNo", rs -> {
			return rs.getString("req_value");
		}, no);
	}
	
	public void deletePartyReqByNo(int no) {
		DaoHelper.update("partyReqDao.deletePartyReqByNo", no);
	}
}
