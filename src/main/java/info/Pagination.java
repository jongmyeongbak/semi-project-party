package info;

public class Pagination {

	private int currentPageNo;
	private int rowsPerPage = 10;
	private int pageSize = 5;
	private int totalRows;
	
	public Pagination(int currentPageNo, int totalRows) {
		super();
		this.currentPageNo = currentPageNo;
		this.totalRows = totalRows;
	}
	public Pagination(int currentPageNo, int rowsPerPage, int totalRows) {
		super();
		this.currentPageNo = currentPageNo;
		this.rowsPerPage = rowsPerPage;
		this.totalRows = totalRows;
	}

	public int getCurrentPageNo() {
		return currentPageNo;
	}
	public void setCurrentPageNo(int currentPageNo) {
		this.currentPageNo = currentPageNo;
	}
	public int getRowsPerPage() {
		return rowsPerPage;
	}
	public void setRowsPerPage(int rowsPerPage) {
		this.rowsPerPage = rowsPerPage;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getTotalRows() {
		return totalRows;
	}
	public void setTotalRows(int totalRows) {
		this.totalRows = totalRows;
	}
	
	private int totalPages;
	private int firstPageNoOnPageList;
	private int lastPageNoOnPageList;
	private int firstRow;
	private int lastRow;

	public int getTotalPages() {
		totalPages = (totalRows - 1) / rowsPerPage + 1;
		return totalPages;
	}
	
	public int getFirstPageNoOnPageList() {
		firstPageNoOnPageList = (currentPageNo - 1) / pageSize * pageSize + 1;
		return firstPageNoOnPageList;
	}

	public int getLastPageNoOnPageList() {
		lastPageNoOnPageList = ((currentPageNo - 1) / pageSize + 1) * pageSize;
		return (lastPageNoOnPageList > getTotalPages()) ? totalPages : lastPageNoOnPageList;
	}

	public int getFirstRow() {
		firstRow = (currentPageNo - 1) * rowsPerPage + 1;
		return firstRow;
	}

	public int getLastRow() {
		lastRow = currentPageNo * rowsPerPage;
		return lastRow;
	}
}
