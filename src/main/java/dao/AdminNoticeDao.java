package dao;

import java.util.Date;
import java.util.List;

import util.DaoHelper;
import vo.Board;
import vo.User;

public class AdminNoticeDao {

	private static AdminNoticeDao instance = new AdminNoticeDao();
	private AdminNoticeDao() {}
	public static AdminNoticeDao getInstance() {
		return instance;
	}
	
	public int getNoticesSeq() {
		return DaoHelper.selectOne("adminNoticeDao.getNoticesSeq", rs -> {
			return rs.getInt("nextval");
		});
	}
	
	public void insertNotice(Board board) {
		DaoHelper.update("adminNoticeDao.insertNotice",
				board.getNo(),
				board.getTitle(),
				board.getContent(),
				board.getUser().getId());
	}
	public void insertNotice(Board board, Date date) {
		DaoHelper.update("adminNoticeDao.insertNoticeWithDate",
				board.getNo(),
				board.getTitle(),
				board.getContent(),
				board.getUser().getId(),
				date);
	}
	
	public int getTotalRows() {
		return DaoHelper.selectOne("adminNoticeDao.getTotalRows", rs -> {
			return rs.getInt("cnt");
		});
	}
	public int getTotalRows(String deleted) {
		return DaoHelper.selectOne("adminNoticeDao.getTotalRowsWithDeleted", rs -> {
			return rs.getInt("cnt");
		}, deleted);
	}
	
	public List<Board> getNotices(int first, int last) {
		return DaoHelper.selectList("adminNoticeDao.getNotices", rs -> {
			Board board = new Board(rs.getInt("notice_no"));
			board.setTitle(rs.getString("notice_title"));
			board.setReadCnt(rs.getInt("notice_read_cnt"));
			board.setDeleted(rs.getString("notice_deleted"));
			board.setUpdateDate(rs.getDate("notice_update_date"));
			board.setCreateDate(rs.getDate("notice_create_date"));
			User user = new User();
			user.setNickname(rs.getString("user_nickname"));
			board.setUser(user);
			return board;
		}, first, last);
	}
	public List<Board> getNotices(String deleted, int first, int last) {
		return DaoHelper.selectList("adminNoticeDao.getNoticesWithDelete", rs -> {
			Board board = new Board(rs.getInt("notice_no"));
			board.setTitle(rs.getString("notice_title"));
			board.setReadCnt(rs.getInt("notice_read_cnt"));
			board.setUpdateDate(rs.getDate("notice_update_date"));
			board.setCreateDate(rs.getDate("notice_create_date"));
			User user = new User();
			user.setNickname(rs.getString("user_nickname"));
			board.setUser(user);
			return board;
		}, deleted, first, last);
	}
	
	public Board getNoticeByNo(int no) {
		return DaoHelper.selectOne("adninNoticeDao.getNoticeByNo", rs -> {
			Board board = new Board(no);
			board.setTitle(rs.getString("notice_title"));
			board.setContent(rs.getString("notice_content"));
			board.setReadCnt(rs.getInt("notice_read_cnt"));
			board.setDeleted(rs.getString("notice_deleted"));
			board.setUpdateDate(rs.getDate("notice_update_date"));
			board.setCreateDate(rs.getDate("notice_create_date"));
			User user = new User(rs.getString("user_id"));
			user.setNickname(rs.getString("user_nickname"));
			board.setUser(user);
			return board;
		}, no);
	}
	
	public void updateNotice(Board board) {
		DaoHelper.update("adminNoticeDao.updateNotice",
				board.getTitle(),
				board.getContent(),
				board.getNo());
	}
	
	public void increaseReadCnt(int no) {
		DaoHelper.update("adminNoticeDao.increaseReadCnt", no);
	}
}
