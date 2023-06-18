package dao;

import java.util.List;

import util.DaoHelper;
import vo.Board;
import vo.Party;
import vo.User;

public class BoardDao {
	
	private static BoardDao instance = new BoardDao();
	private BoardDao () {}
	public static BoardDao getInstance() {
		return instance;
	}
	
	// 게시판 업데이트
	public void updateBoard(Board board) {
		DaoHelper.update("boardDao.updateBoard", board.getTitle(),
												 board.getContent(),
												 board.getCommentCnt(),
											     board.getDeleted(),
											     board.getFilename(),
											     board.getNo());
	}
	// 게시판 번호로 게시판 조회
	public Board getBoardByBoardNo(int boardNo) {
		return DaoHelper.selectOne("boardDao.getBoardByBoardNo", rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("board_no"));
			board.setUser(new User(rs.getString("user_id")));
			board.setParty(new Party(rs.getInt("party_no")));
			board.setTitle(rs.getString("board_title"));
			board.setContent(rs.getString("board_content"));
			board.setCommentCnt(rs.getInt("board_comment_cnt"));
			board.setDeleted(rs.getString("board_deleted"));
			board.setUpdateDate(rs.getDate("board_update_date"));
			board.setCreateDate(rs.getDate("board_create_date"));
			board.setFilename(rs.getString("board_filename"));
			
			return board;
		}, boardNo);
	}
	
	// 파티 게시판 생성
	public void insertBoard(Board board) {
		DaoHelper.update("boardDao.insertBoard", board.getUser().getId(),
												 board.getParty().getNo(),
												 board.getTitle(),
												 board.getContent(),
												 board.getFilename());
	}
	
	// 파티 번호로 파티에 생성된 게시판들을 조회
	public List<Board> getBoardsByPartyNo(int partyNo, int first, int last) {
		return DaoHelper.selectList("boardDao.getBoardsByPartyNo", rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("board_no"));
			board.setUser(new User(rs.getString("user_id"), rs.getString("user_nickname")));
			board.setParty(new Party(rs.getInt("party_no")));
			board.setTitle(rs.getString("board_title"));
			board.setContent(rs.getString("board_content"));
			board.setCommentCnt(rs.getInt("board_comment_cnt"));
			board.setDeleted(rs.getString("board_deleted"));
			board.setCreateDate(rs.getDate("board_create_date"));
			board.setFilename(rs.getString("board_filename"));
			
			return board;
		}, partyNo, first, last);
	}

	// 파티에 생성된 게시물 전체 갯수(행) 조회
	public int getBoardsTotalRowsByPartyNo(int partyNo) {
		return DaoHelper.selectOne("boardDao.getBoardsTotalRowsByPartyNo", rs -> {
			return rs.getInt("cnt");
		}, partyNo);
	}
}
