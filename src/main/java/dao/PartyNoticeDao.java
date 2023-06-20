package dao;

import java.util.List;

import util.DaoHelper;
import vo.PartyNotice;
import vo.User;

public class PartyNoticeDao {

	private static PartyNoticeDao instance = new PartyNoticeDao();
	private PartyNoticeDao() {}
	public static PartyNoticeDao getInstance() {
		return instance;
	}
	
	public void updatePartyNotice(PartyNotice partyNotice) {
		DaoHelper.update("partyNoticeDao.updatePartyNotice", partyNotice.getTitle(),
															 partyNotice.getContent(),
															 partyNotice.getReadCnt(),
															 partyNotice.getDeleted(),
															 partyNotice.getNo());
	}
	
	// 새 공지사항을 전달받아서 테이블에 저장한다.
	public void insertPartyNotice(PartyNotice partyNotice) {
		DaoHelper.update("partyNoticeDao.insertPartyNotice", partyNotice.getParty().getNo(),
															 partyNotice.getTitle(),
															 partyNotice.getContent(),
															 partyNotice.getUser().getId());
	}
	
	public void deletePartyNoticeByNo(int no) {
		DaoHelper.update("partyNoticeDao.deletePartyNoticeByNo", no);
	}
	
	
	public void increasePartyNoticeReadCnt(int no) {
		DaoHelper.update("partyNoticeDao.increasePartyNoticeReadcnt", no);
	}
	
	public int getPartyNoticeSeq() {
		return DaoHelper.selectOne("partyNoticeDao.getPartyNoticesSeq", rs->{
			return rs.getInt("nextval");
		});
	}
	
	public int getTotalRows() {
		return DaoHelper.selectOne("partyNoticeDao.getTotalRows", rs-> {
			return rs.getInt("cnt");
		});
	}
	
	public int getWithDeletedTotalRows(String deleted) {
		return DaoHelper.selectOne("partyNoticeDao.getWithDeletedTotalRows", rs-> {
			return rs.getInt("cnt");
		}, 'N');
	}
	
	public List<PartyNotice> getAllNoticesByPartyNo(int partyNo, int first, int last) {
		return DaoHelper.selectList("partyNoticeDao.getAllPartyNoticesByPartyNo", rs->{
			PartyNotice partyNotice = new PartyNotice();
			partyNotice.setNo(rs.getInt("notice_no"));
			partyNotice.setTitle(rs.getString("notice_title"));
			partyNotice.setReadCnt(rs.getInt("notice_read_cnt"));
			partyNotice.setCreateDate(rs.getDate("notice_create_date"));
			
			User user = new User(rs.getString("user_id"), rs.getString("user_nickname"));
			user.setNickname(rs.getString("user_nickname"));
			partyNotice.setUser(user);
			
			return partyNotice;
		}, partyNo, first, last);
	}
		
	public PartyNotice getPartyNoticeByNo(int no) {
		return DaoHelper.selectOne("partyNoticeDao.getPartyNoticeByNo", rs-> {
			PartyNotice partyNotice = new PartyNotice();
			partyNotice.setNo(rs.getInt("notice_no"));
			partyNotice.setTitle(rs.getString("notice_title"));
			partyNotice.setReadCnt(rs.getInt("notice_read_cnt"));
			partyNotice.setUpdateDate(rs.getDate("notice_update_date"));
			partyNotice.setCreateDate(rs.getDate("notice_create_date"));
			partyNotice.setContent(rs.getString("notice_content"));
			partyNotice.setDeleted(rs.getString("notice_deleted"));
			
			User user = new User(rs.getString("user_id"));
			user.setNickname(rs.getString("user_nickname"));
			partyNotice.setUser(user);
			
			return partyNotice;
		}, no);
	}

}

