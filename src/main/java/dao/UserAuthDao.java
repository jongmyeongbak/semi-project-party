package dao;

import util.DaoHelper;

public class UserAuthDao {

	private static UserAuthDao instance = new UserAuthDao();
	private UserAuthDao() {}
	public static UserAuthDao getInstance() {
		return instance;
	}
	
	public void insertUserAuth(String id, int authNo) {
		DaoHelper.update("userAuthDao.insertUserAuth", id, authNo);	
	}
	
	public int getAuthById(String id) {
		return DaoHelper.selectOne("userAuthDao.getAuthById", rs -> {
			return rs.getInt("auth_no"); 
		}, id);
	}
}
