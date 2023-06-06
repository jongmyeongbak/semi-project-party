package vo;

import java.util.Date;

public class Party {

	private int no;
	private String name;
	private User manager;
	private Category category;
	private int curCnt;
	private int quota;
	private String reqGender;
	private Date reqBirthdate;
	private String status;
	private String description;
	private Date updateDate;
	private Date createDate;
	
	public Party() {
	}
	public Party(int no) {
		this.no = no;
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
	public User getManager() {
		return manager;
	}
	public void setManager(User manager) {
		this.manager = manager;
	}
	public Category getCategory() {
		return category;
	}
	public void setCategory(Category category) {
		this.category = category;
	}
	public int getCurCnt() {
		return curCnt;
	}
	public void setCurCnt(int curCnt) {
		this.curCnt = curCnt;
	}
	public int getQuota() {
		return quota;
	}
	public void setQuota(int quota) {
		this.quota = quota;
	}
	public String getReqGender() {
		return reqGender;
	}
	public void setReqGender(String reqGender) {
		this.reqGender = reqGender;
	}
	public Date getReqBirthdate() {
		return reqBirthdate;
	}
	public void setReqBirthdate(Date reqBirthdate) {
		this.reqBirthdate = reqBirthdate;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
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
