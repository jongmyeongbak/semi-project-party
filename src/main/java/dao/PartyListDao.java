package dao;

import java.util.List;

import util.DaoHelper;
import vo.Category;
import vo.Party;

public class PartyListDao {

	private static PartyListDao instance = new PartyListDao();
	private PartyListDao() {}
	public static PartyListDao getInstance() {
		return instance;
	}
	
	
	
	// 생성된 모든 파티 조회하기
	public List<Party> getAllParties(int first, int last) {
		return DaoHelper.selectList("partyListDao.getAllParties", rs -> {
			Party party = new Party();
			party.setNo(rs.getInt("party_no"));
			party.setName(rs.getString("party_name"));
			party.setDescription(rs.getString("party_description"));
			party.setFilename(rs.getString("party_filename"));
			party.setCategory(new Category(rs.getInt("cat_no"), rs.getString("cat_name")));
			
			return party;
		},first, last);
	}
	
	public int getAllPartiesTotalRows(String loginId) {
		return DaoHelper.selectOne("partyListDao.getPartiesWithoutUserTotalRows", rs -> {
			return rs.getInt("totalRows");
		}, loginId);
	}
	
	// 로그인된 유저가 포함되지 않은 생성된 파티 조회하기
	public List<Party> getPartiesWithoutUser(String loginId, int first, int last) {
		return DaoHelper.selectList("partyListDao.getPartiesWithoutUser", rs -> {
			Party party = new Party();
			party.setNo(rs.getInt("party_no"));
			party.setName(rs.getString("party_name"));
			party.setDescription(rs.getString("party_description"));
			party.setFilename(rs.getString("party_filename"));
			party.setCategory(new Category(rs.getInt("cat_no"), rs.getString("cat_name")));
			
			return party;
		}, loginId, first, last);
	}
	
	// 로그인된 사용자가 가입한 파티 조회하기
	public List<Party> getUserRegPartiesByUserId(String loginId){
		return DaoHelper.selectList("partyListDao.getUserRegPartiesByUserId", rs -> {
			Party party = new Party();
			party.setNo(rs.getInt("party_no"));
			party.setName(rs.getString("party_name"));
			party.setCurCnt(rs.getInt("party_cur_cnt"));
			party.setFilename(rs.getString("party_filename"));
			
			return party;
		}, loginId);
	}
	
	// 파티 생성 카테고리 조회
	public List<Category> getCategories() {
		return DaoHelper.selectList("partyListDao.getCategories", rs-> {
			Category category = new Category();
			category.setNo(rs.getInt("cat_no"));
			category.setName(rs.getString("cat_name"));
			
			return category;
		});
	}
	
}
