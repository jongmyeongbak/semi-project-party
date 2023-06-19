package dao;

import java.util.List;

import util.DaoHelper;
import vo.Category;
import vo.GuestBook;
import vo.Party;
import vo.User;

public class GuestBookDao {
	
	private static GuestBookDao instance = new GuestBookDao();
	private GuestBookDao() {}
	public static GuestBookDao getInstance() {
		return instance;
	}
	
	// 방명록 등록하기
	public void insertGuestBook (GuestBook guestbook) {
		DaoHelper.update("guestBookDao.insertGbook", guestbook.getUser().getId(),
													 guestbook.getParty().getNo(),
													 guestbook.getContent());	
	}	
		
	// 파티번호에 해당하는 방명록 조회하기
	public List<GuestBook> getGuestBooksByPartyNo(int partyNo){
		return DaoHelper.selectList("guestBookDao.getGbooksByPartyNo", rs -> {
			GuestBook guestBook = new GuestBook();
			guestBook.setNo(rs.getInt("gb_no"));
			guestBook.setParty(new Party(rs.getInt("party_no")));
			guestBook.setUser(new User(rs.getString("user_id"),rs.getString("user_nickname")));
			guestBook.setContent(rs.getString("gb_content"));
			guestBook.setCreateDate(rs.getDate("gb_create_date"));
			return guestBook;
		},partyNo);
	}
	
	// 파티번호를 통해 페이지네이션된 방명록 얻어오기
	public List<GuestBook> getGuestBooksByPartyNoPage(int partyNo, int first, int last){
		return DaoHelper.selectList("guestBookDao.getGbooksByPartyNoPage", rs -> {
			GuestBook guestBook = new GuestBook();
			guestBook.setNo(rs.getInt("gb_no"));
			guestBook.setParty(new Party(rs.getInt("party_no")));
			guestBook.setUser(new User(rs.getString("user_id"),rs.getString("user_nickname")));
			guestBook.setContent(rs.getString("gb_content"));
			guestBook.setCreateDate(rs.getDate("gb_create_date"));
			return guestBook;
		},partyNo,first,last);
	}
	// 방명록No에 해당하는 방명록 조회하기
	public GuestBook getGuestBookByGbNo(int gbNo) {
		return DaoHelper.selectOne("guestBookDao.getGbookByGbNo", rs -> {
			GuestBook guestBook =  new GuestBook();
			guestBook.setNo(rs.getInt("gb_no"));
			guestBook.setParty(new Party(rs.getInt("party_no")));
			guestBook.setUser(new User(rs.getString("user_id")));
			guestBook.setContent(rs.getString("gb_content"));
			guestBook.setCreateDate(rs.getDate("gb_create_date"));
			return guestBook;
		}, gbNo);
	}
		
	// 방명록 삭제하기
	public void deleteGuestBookByGbNo(int gbNo){
		DaoHelper.update("guestBookDao.deleteGbookByNo", gbNo);
	}
	
	// 페이지네이션에 쓰이는 totalrows (일단 안쓰임 getTotalRowsByNo로 대체) 
	public int getTotalRows() {
		return DaoHelper.selectOne("guestBookDao.getTotalRows", rs -> {
			return rs.getInt("cnt");
		});
	}
	
	// 파티번호에 해당하는 방명록의 총 수 조회하기
	public int getTotalRowsByPartyNo(int partyNo) {
	    return DaoHelper.selectOne("guestBookDao.getTotalRowsByPartyNo", rs -> {
	        return rs.getInt("cnt");
	    }, partyNo);
	}
}
