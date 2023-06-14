package dao;

import util.DaoHelper;
import vo.Category;
import vo.Party;
import vo.User;

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
	
	public Party getPartyByNo(int no) {
		return DaoHelper.selectOne("partyDao.getPartyByNo", rs -> {
			Party party = new Party();
			party.setNo(rs.getInt("party_no"));
			party.setName(rs.getString("party_name"));
			party.setManager(new User(rs.getString("manager_id")));
			party.setCurCnt(rs.getInt("party_cur_cnt"));
			party.setQuota(rs.getInt("party_quota"));
			party.setDescription(rs.getString("party_description"));
			party.setUpdateDate(rs.getDate("party_update_date"));
			party.setCreateDate(rs.getDate("party_create_date"));
			party.setFilename(rs.getString("party_filename"));
			Category category = new Category();
			category.setName(rs.getString("cat_name"));
			category.setNo(rs.getInt("cat_no"));
			party.setCategory(category);
			
			return party;
		}, no);
	}
	
	public void updateParty(Party party) {
		DaoHelper.update("partyDao.updateParty", 
				party.getName(),
				party.getQuota(),
				party.getDescription(),
				party.getFilename(),
				party.getNo());
	}
}
