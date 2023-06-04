package vo;

import java.util.Date;

public class PartyAccess {

	private int no;
	private User user;
	private Party party;
	private String roleName;
	private Date createDate;
	private String description;

	public PartyAccess() {
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
	public String getRoleName() {
		return roleName;
	}
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
}
