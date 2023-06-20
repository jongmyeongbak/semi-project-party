package dao;

import java.util.List;

import dto.UserPartyDto;
import util.DaoHelper;

public class UserPartyDtoDao {

	private static UserPartyDtoDao instance = new UserPartyDtoDao();
	private UserPartyDtoDao() {}
	public static UserPartyDtoDao getInstance() {
		return instance;
	}
	
	public List<UserPartyDto> getAllMyParties(String userId) {
		return DaoHelper.selectList("userPartyDtoDao.getAllMyParties", rs -> {
			UserPartyDto dto = new UserPartyDto();
			dto.setNo(rs.getInt("party_no"));
			dto.setName(rs.getString("party_name"));
			dto.setFilename(rs.getString("party_filename"));
			dto.setAccessCreateDate(rs.getDate("access_create_date"));
			dto.setIsFavorite(rs.getBoolean("favorite"));
			dto.setIsManaged(rs.getBoolean("managing"));
			return dto;
		}, userId);
	}
	
	public List<UserPartyDto> getAllMyFavoriteParties(String userId) {
		return DaoHelper.selectList("userPartyDtoDao.getAllMyFavoriteParties", rs -> {
			UserPartyDto dto = new UserPartyDto();
			dto.setNo(rs.getInt("party_no"));
			dto.setName(rs.getString("party_name"));
			dto.setFilename(rs.getString("party_filename"));
			dto.setAccessCreateDate(rs.getDate("access_create_date"));
			dto.setIsFavorite(true);
			dto.setIsManaged(rs.getBoolean("managing"));
			dto.setDisplayRank(rs.getInt("display_rank"));
			return dto;
		}, userId);
	}

	public List<UserPartyDto> getAllMyManagedParties(String userId) {
		return DaoHelper.selectList("userPartyDtoDao.getAllMyManagedParties", rs -> {
			UserPartyDto dto = new UserPartyDto();
			dto.setNo(rs.getInt("party_no"));
			dto.setName(rs.getString("party_name"));
			dto.setFilename(rs.getString("party_filename"));
			dto.setAccessCreateDate(rs.getDate("access_create_date"));
			dto.setIsFavorite(rs.getBoolean("favorite"));
			dto.setIsManaged(true);
			return dto;
		}, userId);
	}
}
