package dao;

import java.util.List;

import util.DaoHelper;
import vo.Category;

public class PartyCategoryDao {
	
	private static PartyCategoryDao instance = new PartyCategoryDao();
	private PartyCategoryDao() {}
	public static PartyCategoryDao getInstance() {
		return instance;
	}
	
	public List<Category> getAllCategories() {
		return DaoHelper.selectList("partyCategoryDao.getAllCategories", rs -> {
			Category category = new Category();
			category.setName(rs.getString("cat_name"));
			category.setNo(rs.getInt("cat_no"));
			
			return category;
		});
	}
}
