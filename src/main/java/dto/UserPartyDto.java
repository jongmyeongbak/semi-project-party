package dto;

import java.util.Date;

public class UserPartyDto {

	private int no;
	private String name;
	private String filename; // not fileName
//	private int authNo;
	private Date AccessCreateDate;
	Boolean isFavorite;
	Boolean isManaged;
	int displayRank;

	public UserPartyDto() {
	}
	
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
//	public int getAuthNo() {
//		return authNo;
//	}
//	public void setAuthNo(int authNo) {
//		this.authNo = authNo;
//	}
	public Date getAccessCreateDate() {
		return AccessCreateDate;
	}
	public void setAccessCreateDate(Date accessCreateDate) {
		AccessCreateDate = accessCreateDate;
	}
	public Boolean getIsFavorite() {
		return isFavorite;
	}
	public void setIsFavorite(Boolean isFavorite) {
		this.isFavorite = isFavorite;
	}
	public Boolean getIsManaged() {
		return isManaged;
	}
	public void setIsManaged(Boolean isManaged) {
		this.isManaged = isManaged;
	}
	public int getDisplayRank() {
		return displayRank;
	}
	public void setDisplayRank(int displayRank) {
		this.displayRank = displayRank;
	}
}
