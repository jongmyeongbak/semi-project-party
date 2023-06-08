package dao;

import java.util.List;

import util.DaoHelper;
import vo.Category;

public class PartyListDao {

	private static PartyListDao instance = new PartyListDao();
	private PartyListDao() {}
	public static PartyListDao getInstance() {
		return instance;
	}
	
	public List<Category> getCategories() {
		return DaoHelper.selectList("partyListDao.getCategories", rs-> {
			Category category = new Category();
			category.setNo(rs.getInt("cat_no"));
			category.setName(rs.getString("cat_name"));
			
			return category;
		});
	}
	
}
