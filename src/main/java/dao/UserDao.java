package dao;

import util.DaoHelper;
import vo.User;

public class UserDao {
	
	private static UserDao instance = new UserDao();
	private UserDao() {}
	public static UserDao getInstance() {
		return instance;
	}
	
	public void insertUser (User user) {
		DaoHelper.update("userDao.insertUser", user.getId(),
											   user.getPassword(),
											   user.getName(),
											   user.getNickname(),
											   user.getGender(),
											   user.getBirthdate(),
											   user.getEmail(),
											   user.getTel());	
	}
	
	public User getUserByEmail(String eamil) {
		return DaoHelper.selectOne("userDao.getUserByEmail", rs -> {
			User user = new User();
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setNickname(rs.getString("user_nickname"));
			user.setGender(rs.getString("user_gender"));
			user.setBirthdate(rs.getDate("user_birthdate"));
			user.setEmail(rs.getString("user_email"));
			user.setTel(rs.getString("user_tel"));
			user.setDeleted(rs.getString("user_deleted"));
			user.setUpdateDate(rs.getDate("user_update_date"));
			user.setCreateDate(rs.getDate("user_create_date"));
			
			return user;
		}, eamil);
	}

	public User getUserById(String id) {
		return DaoHelper.selectOne("userDao.getUserById", rs -> {
			User user = new User();
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setNickname(rs.getString("user_nickname"));
			user.setGender(rs.getString("user_gender"));
			user.setBirthdate(rs.getDate("user_birthdate"));
			user.setEmail(rs.getString("user_email"));
			user.setTel(rs.getString("user_tel"));
			user.setDeleted(rs.getString("user_deleted"));
			user.setUpdateDate(rs.getDate("user_update_date"));
			user.setCreateDate(rs.getDate("user_create_date"));
			
			return user;
		}, id);
	}
	
}
