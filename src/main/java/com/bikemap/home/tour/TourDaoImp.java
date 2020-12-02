package com.bikemap.home.tour;

import java.util.List;

public interface TourDaoImp {
	
	//게시판 목록보기(전체레코드선택)
	public List<TourVO> selectAllTour(PagingVO vo);
	
	//총 레코드 수
	public int getTotalTourRecord(PagingVO vo);
	
	//게시판 목록보기 (검색 결과)
	public List<TourVO> selectTour(PagingVO vo);
	
	//검색 레코드 수 구하기
	public int getTourRecord(PagingVO vo);
	
	//레코드 추가 -글쓰기
	public int tourInsert(TourVO vo);
	
	//게시판 글보기(레코드 하나 선택)
	public TourVO tourSelect(int noboard);
	
}
