package dao;

import util.DaoHelper;
import vo.Category;
import vo.Party;

public class PartyDao {

	private static PartyDao instance = new PartyDao();
	private PartyDao() {}
	public static PartyDao getInstance() {
		return instance;
	}
	
	public int getPartySeq() {
		return DaoHelper.selectOne("partyDao.getPartySeq", rs -> {
			return rs.getInt("nextval");
		});
	}
	
	public void insertParty(Party party) {
		DaoHelper.update("partyDao.insertParty", 
				party.getNo(),
				party.getName(), 
				party.getManager().getId(),
				party.getCategory().getNo(),
				party.getQuota(),
				party.getDescription(),
				party.getFilename());
	}
	
	public Party getPartyByName(String name) {
		return DaoHelper.selectOne("partyDao.getPartyByName", rs -> {
			Party party = new Party();
			party.setName(rs.getString("party_name"));
			
			return party;
		}, name);
	}
}
