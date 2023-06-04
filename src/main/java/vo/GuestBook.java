package vo;

import java.util.Date;

public class GuestBook {

	private int no;
	private User user;
	private Party party;
	private String content;
	private Date createDate;
	
	public GuestBook() {
	}
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Party getParty() {
		return party;
	}
	public void setParty(Party party) {
		this.party = party;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
}
