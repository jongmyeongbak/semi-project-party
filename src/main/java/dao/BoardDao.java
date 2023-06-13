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
	
	// 파티 번호로 파티에 생성된 게시판들을 조회
	public List<Board> getBoardsByPartyNo(int no) {
		return DaoHelper.selectList("boardDao.getBoardsByPartyNo", rs -> {
			Board board = new Board();
			board.setNo(rs.getInt("board_no"));
			board.setUser(new User(rs.getString("user_id"), rs.getString("user_nickname")));
			board.setParty(new Party(rs.getInt("party_no")));
			board.setTitle(rs.getString("board_title"));
			board.setContent(rs.getString("board_content"));
			board.setCommentCnt(rs.getInt("board_comment_cnt"));
			board.setDeleted(rs.getString("board_deleted"));
			board.setUpdateDate(rs.getDate("board_update_date"));
			board.setFilename(rs.getString("board_filename"));
			
			return board;
		}, no);
	}

}
