package vo;

import java.util.Date;

public class Comment {

	private int no;
	private String content;
	private User user;
	private Board board;
	private Date updateDate;
	private Date createDate;
	
	public Comment() {
	}
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Board getBoard() {
		return board;
	}
	public void setBoard(Board board) {
		this.board = board;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
}
