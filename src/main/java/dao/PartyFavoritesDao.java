package dao;

import util.DaoHelper;

public class PartyFavoritesDao {

	private static PartyFavoritesDao instance = new PartyFavoritesDao();
	private PartyFavoritesDao() {}
	public static PartyFavoritesDao getInstance() {
		return instance;
	}
	
	public void insertPartyFavorite(String userId, int partyNo) {
		DaoHelper.update("partyFavoritesDao.insertPartyFavorite", userId, partyNo, userId, userId, partyNo, userId, partyNo);
	}
	public void deletePartyFavorite(String userId, int partyNo) {
		DaoHelper.update("partyFavoritesDao.deletePartyFavorite", userId, partyNo);
	}
	
	public void deletePartyFavoritesByuserId(String userId) {
		DaoHelper.update("partyFavoritesDao.deletePartyFavoritesByuserId", userId);
	}
	
}
