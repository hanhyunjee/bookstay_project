package kr.ac.spring.board.vo;

public class Pagination {
    
	private int listSize = 10;                //�ʱⰪ���� ��ϰ����� 10���� ����

	private int rangeSize = 10;            //�ʱⰪ���� ������������ 10���� ����

	private int page;

	private int range;

	private int listCnt;

	private int pageCnt;

	private int startPage;

	private int startList;
	
	private int endList;

	private int endPage;

	private boolean prev;  // true�� prev��ư

	private boolean next;  // ture�� next��ư

	

	public int getRangeSize() {

		return rangeSize;

	}



	public int getPage() {

		return page;

	}



	public void setPage(int page) {

		this.page = page;

	}



	public int getRange() {

		return range;

	}



	public void setRange(int range) {

		this.range = range;

	}



	public int getStartPage() {

		return startPage;

	}



	public void setStartPage(int startPage) {

		this.startPage = startPage;

	}



	public int getEndPage() {

		return endPage;

	}



	public void setEndPage(int endPage) {

		this.endPage = endPage;

	}



	public boolean isPrev() {

		return prev;

	}



	public void setPrev(boolean prev) {

		this.prev = prev;

	}



	public boolean isNext() {

		return next;

	}



	public void setNext(boolean next) {

		this.next = next;

	}



	public int getListSize() {

		return listSize;

	}



	public void setListSize(int listSize) {

		this.listSize = listSize;

	}

	

	public int getListCnt() {

		return listCnt;

	}



	public void setListCnt(int listCnt) {

		this.listCnt = listCnt;

	}

	

	public int getStartList() {

		return startList;

	}

	public void pageInfo(int page, int range, int listCnt) {

		this.page = page;

		this.range = range;

		this.listCnt = listCnt;

		
		// listSize : �� ���������� ���̴� �� ���� = 10 
		// rangesize : �۸�� ��ȣ �ִ� ���� = 10 ( �ʰ��Ǹ� next ��ư����)
		//��ü ��������. ��ü�ۼ��� 10���� ��������� �ø���(����)

		this.pageCnt = (int) Math.ceil((double)listCnt/listSize);

		

		//���� ������. range�� 1�̸� ���������� = 1
		// range�� 2�̸� ���������� = 11
		this.startPage = (range - 1) * rangeSize + 1 ;

		

		//�� ������. range�� 1�̸� �������� = 10
		// range�� 2�̸� �������� = 20
		this.endPage = range * rangeSize;

				

		//�Խ��� ���۹�ȣ. 1�������϶� 0, 2�������϶� 10������ ����
		this.startList = (page - 1) * listSize;

		//�Խ��� �� ��ȣ. 1�������϶� 10, 2�������϶� 20���� ����ȣ
		this.endList = startList + rangeSize;
	
		//���� ��ư ����. 
		this.prev = range == 1 ? false : true;

		

		//���� ��ư ����

		this.next = endPage > pageCnt ? false : true;

		if (this.endPage > this.pageCnt) {

			this.endPage = this.pageCnt;

			this.next = false;

		}

	}


}