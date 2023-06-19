package dao;

import java.util.List;

import util.DaoHelper;
import vo.Board;
import vo.Comment;
import vo.User;

public class CommentDao {
	
	private static CommentDao instance = new CommentDao();
	private CommentDao() {}
	public static CommentDao getInstance() {
		return instance;
	}
	
	// 댓글 번호로 댓글 조회
	public Comment getCommentByNo(int commentNo) {
		return DaoHelper.selectOne("commentDao.getCommentByNo", rs -> {
			Comment comment = new Comment();
			comment.setContent(rs.getString("comment_content"));
			comment.setUser(new User(rs.getString("user_id")));
			comment.setBoard(new Board(rs.getInt("board_no")));
			
			return comment;
		}, commentNo);
	}
	
	// 게시판에 달린 모든 댓글 조회 (최근두개만조회)
	public List<Comment> getCommentsByBoardNo(int boardNo) {
		return DaoHelper.selectList("commentDao.getCommentsByBoardNo", rs -> {
			Comment comment = new Comment();
			comment.setNo(rs.getInt("comment_no"));
			comment.setContent(rs.getString("comment_content"));
			comment.setCreateDate(rs.getDate("comment_create_date"));
			comment.setUser(new User(rs.getString("user_id"), rs.getString("user_nickname")));
			
			return comment;
		}, boardNo);
	}
	
	// 최근 두개만 조회한 두개의 댓글이 자신이 쓴 댓글인지 확인
	public List<Object[]> getCommentsWithIsMineByBoardNo(int boardNo, String userId) {
		return DaoHelper.selectList("commentDao.getCommentsByBoardNo", rs -> {
			Comment comment = new Comment();
			comment.setNo(rs.getInt("comment_no"));
			comment.setContent(rs.getString("comment_content"));
			comment.setCreateDate(rs.getDate("comment_create_date"));
			comment.setUser(new User(null, rs.getString("user_nickname")));
			String commentUserId = rs.getString("user_id");
			boolean isMine = commentUserId.equals(userId);
			return new Object[] {comment, isMine};
		}, boardNo);
	}
	
	// 게시판에 달린 모든 댓글 조회
	public List<Comment> getAllCommentsByBoardNo(int boardNo) {
		return DaoHelper.selectList("commentDao.getAllCommentsByBoardNo", rs -> {
			Comment comment = new Comment();
			comment.setNo(rs.getInt("comment_no"));
			comment.setContent(rs.getString("comment_content"));
			comment.setCreateDate(rs.getDate("comment_create_date"));
			comment.setUser(new User(rs.getString("user_id"), rs.getString("user_nickname")));
			
			return comment;
		}, boardNo);
	}
	
	// 게시판에 달린 댓글의 전체 갯수(행) 조회
	public int getCommentCntByBoardNo(int boardNo) {
		return DaoHelper.selectOne("commentDao.getCommentCntByBoardNo", rs -> {
			return rs.getInt("cnt");
		}, boardNo);
	}
	
	// 댓글 삭제
	public void deleteComment(int commentNo) {
		DaoHelper.update("commentDao.deleteComment", commentNo);
	}
	
	// 댓글 추가
	public void insertComment(Comment comment) {
		DaoHelper.update("commentDao.insertComment", comment.getContent(),
													 comment.getUser().getId(),
													 comment.getBoard().getNo());
	}

}
