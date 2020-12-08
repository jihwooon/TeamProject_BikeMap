package com.bikemap.home.route;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class RouteController {

	public SqlSession sqlSession;

	public SqlSession getSqlSession() {
		return sqlSession;
	}

	@Autowired
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	@Autowired
	DataSourceTransactionManager transactionManager;
	
	//코스검색
	@RequestMapping("/routeSearch")
	public ModelAndView routeSearch() {
		ModelAndView mav = new ModelAndView();
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		RoutePagingVO pagingVO = new RoutePagingVO();
		List<RouteVO> list ;
		try {
			int totalRecord = dao.searchTotalRecord();
			pagingVO.setTotalRecord(totalRecord);
			
			list = dao.selectRouteAll(pagingVO);
			mav.addObject("list", list);
			mav.addObject("pagingVO", pagingVO);		
		}catch(Exception e) {
			System.out.println("루트 검색 화면 호출 에러 " + e.getMessage());
		}		
		mav.setViewName("route/routeSearch");
		return mav;
	}
	
	@RequestMapping(value="/searchRouteAll", method= {RequestMethod.POST})
	@ResponseBody
	public List<RouteVO> routeSearchAll(RoutePagingVO pagingVO){
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		List<RouteVO> list = new ArrayList<RouteVO>();
		
		try {
			int totalRecord = dao.searchResultRecord(pagingVO);
			pagingVO.setTotalRecord(totalRecord);
			
			list = dao.selectRouteAll(pagingVO);
		}catch(Exception e) {
			System.out.println("전체 루트 검색 에러 " + e.getMessage());
		}
		return list;
	}
	
	// 루트 리스트 검색
	@RequestMapping(value="/searchRouteOk", method= {RequestMethod.POST})
	@ResponseBody
	public List<RouteVO> routeSearchOk(RoutePagingVO pagingVO){
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		List<RouteVO> list = new ArrayList<RouteVO>();
		
		try {
			int totalRecord = dao.searchResultRecord(pagingVO);
			pagingVO.setTotalRecord(totalRecord);
			
			list = dao.selectRouteSearch(pagingVO);
		}catch(Exception e) {
			System.out.println("루트 리스트 검색 에러 " + e.getMessage());
		}
		return list;
	}
	
	// 루트 검색 페이지 페이징 처리
	@RequestMapping(value="/searchRoutePaging", method= {RequestMethod.POST})
	@ResponseBody
	public RoutePagingVO searchRoutePageing(RoutePagingVO pagingVO) {		
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		try {
			int totalRecord = dao.searchResultRecord(pagingVO);
			pagingVO.setTotalRecord(totalRecord);
			
		}catch(Exception e) {
			System.out.println("루트 검색 페이징 에러 " + e.getMessage());
		}
		return pagingVO;
	}

	//코스검색(글보기)
	@RequestMapping("/routeSearchView")
	public ModelAndView routeSearchView(int noboard, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		String logId = (String)session.getAttribute("logId");
		try {
			RouteVO vo = dao.selectRoute(noboard);
			if(vo.getClosed().equals("F")) {
				RoutePlaceVO placeVO = dao.selectRoutePlace(noboard);
				
				mav.addObject("routeVO", vo);
				mav.addObject("placeVO", placeVO);
			}else {
				if(vo.getUserid().equals(logId)) {
					RoutePlaceVO placeVO = dao.selectRoutePlace(noboard);
					
					mav.addObject("routeVO", vo);
					mav.addObject("placeVO", placeVO);
				}
			}
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}
		mav.setViewName("route/routeSearchView");
		return mav;
	}

	// 코스 만들기 이동
	// 코스 만들기 열 때 내 코스 카테고리 목록 가져가기
	@RequestMapping("/courseMap")
	public ModelAndView routeMap(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		RouteDaoImp routeDao = sqlSession.getMapper(RouteDaoImp.class);
		if(session.getAttribute("logId") != null) {
			try {
				String userid  = (String)session.getAttribute("logId");
				List<RouteCateVO> categoryList = routeDao.selectCategory(userid);
				mav.addObject("category", categoryList);
			}catch(Exception e) {
				System.out.println(e.getMessage());
			}
		}
		mav.setViewName("route/routeMap");
		return mav;
	}
	
	// 코스 만들기에서 코스 카테고리 추가
	@RequestMapping(value="/insertCategory", method= {RequestMethod.POST})
	@ResponseBody
	public int insertCategory(HttpSession session, RouteCateVO vo) {
		RouteDaoImp routeDao = sqlSession.getMapper(RouteDaoImp.class);
		int result = 0;
		try {
			vo.setUserid((String)session.getAttribute("logId"));
			result = routeDao.insertCategory(vo);
		}catch(Exception e) {
			System.out.println("코스 카테고리 추가 에러 " + e.getMessage());
		}
		return result;
	}
	
	// 카테고리 리스트 새로 불러오기
	@RequestMapping(value= "/selectCategory")
	@ResponseBody
	public List<RouteCateVO> selectCategory(HttpSession session){
		RouteDaoImp routeDao = sqlSession.getMapper(RouteDaoImp.class);
		String userid  = (String)session.getAttribute("logId");
		List<RouteCateVO> list = new ArrayList<RouteCateVO>();
		
		try {
			list = routeDao.selectCategory(userid);
		}catch(Exception e) {
			System.out.println("루트 카테고리 호출 에러 " +e.getMessage());
		}
		return list;
	}
	
	// 루트 저장 팝업 열기
	@RequestMapping("/routeCollect")
	public ModelAndView routeCollectPopup(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		RouteDaoImp routeDao = sqlSession.getMapper(RouteDaoImp.class);
		if(session.getAttribute("logId") != null) {
			try {
				String userid  = (String)session.getAttribute("logId");
				List<RouteCateVO> categoryList = routeDao.selectCategory(userid);
				mav.addObject("category", categoryList);
			}catch(Exception e) {
				System.out.println(e.getMessage());
			}
		}
		mav.setViewName("popup/routeCollect");
		return mav;
	}
	
	// 루트 저장하기
	@RequestMapping("/insertRouteList")
	@ResponseBody
	public int insertRouteList(HttpSession session, RouteListVO vo) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		vo.setUserid((String)session.getAttribute("logId"));
		
		try {
			// 중복 체크
			result = dao.chkRouteList(vo);			
			if(result >= 1) {
				return 2;
			}else {
				// 신규 리스트 저장
				result = dao.insertRouteList(vo);
			}
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}		
		return result;
	}
	
	@RequestMapping(value="/insertRoute", method= {RequestMethod.POST,RequestMethod.GET})
	@ResponseBody
	public int insertRoute(HttpSession session, RouteVO routeVO, RouteListVO routeListVO, RoutePlaceVO routePlaceVO) {
		int result = 0;
		String userid = (String)session.getAttribute("logId");
		routeVO.setUserid(userid);
		routeListVO.setUserid(userid);
		
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		
		TransactionStatus status = transactionManager.getTransaction(def);
		
		try {
			// 루트 저장
			result = dao.insertRoute(routeVO);
			// 루트 저장 성공 시
			if(result == 1) {
				// 루트 번호를 구하여
				int noBoard = dao.lastRouteNo(userid);
				
				// 1. 루트 리스트 저장
				routeListVO.setNoboard(noBoard);
				dao.insertRouteList(routeListVO);
				
				// 2. 장소 리스트 저장
				routePlaceVO.setNoboard(noBoard);
				dao.insertRoutePlaceList(routePlaceVO);
			}
			
			transactionManager.commit(status);
		}catch(Exception e) {
			System.out.println(e.getMessage());
			transactionManager.rollback(status);
			result = 0;
		}
		return result;
	}
	
	// 평점 부여하기
	@RequestMapping(value="/rateRoute", method=RequestMethod.POST)
	@ResponseBody
	public int rateRoute(HttpSession session, RouteVO vo) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		
		TransactionStatus status = transactionManager.getTransaction(def);
		
		vo.setUserid((String)session.getAttribute("logId"));
		try {			
			result = dao.checkRateAlready(vo);
			if(result == 1) {
				return 2; // 이미 평점을 줬을 경우 2를 리턴
			}else {
				// 평점이 없을 경우 평점 부여 / routerate 테이블에 아이디 추가
				result = dao.ratingRoute(vo);
				if(result == 1) {
					result = dao.insertRouteRateList(vo);
				}
			}
			transactionManager.commit(status);
		}catch(Exception e) {
			System.out.println("평점 주기 에러 " + e.getMessage());
			transactionManager.rollback(status);
		}
		return result;
	}
	
	// 평점 재호출
	@RequestMapping(value="/selectRouteRating", method=RequestMethod.POST)
	@ResponseBody
	public RouteVO selectRouteRating(RouteVO vo) {
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		try {
			vo = dao.selectRouteRating(vo);
		}catch(Exception e) {
			System.out.println("평점 호출 에러" +e.getMessage());
		}
		return vo;
	}
	
	// 썸네일용 루트 검색
	@RequestMapping("/selectRouteForThumbnail")
	@ResponseBody
	public RouteVO selectRouteForThumbnail(int noboard) {
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		RouteVO vo = new RouteVO();
		try {
			vo = dao.selectRoute2(noboard);
		}catch(Exception e) {
			System.out.println("썸네일용 데이터 호출 에러"+ e.getMessage());
		}
		return vo;
	}
	
	
	///// 루트 검색 -- 레퍼런스 용도
	@RequestMapping(value="/searchReference")
	@ResponseBody
	public List<RouteVO> searchReference(@RequestParam("searchWord") String searchWord){
		List<RouteVO> list = new ArrayList<RouteVO>();
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		try {
			list = dao.searchReference(searchWord);
		}catch(Exception e) {
			System.out.println("레퍼런스 검색 에러" + e.getMessage());
		}
		return list;
	}
	
	// 검색한 레퍼런스로 맵 세팅하기
	@RequestMapping("/setMap")
	@ResponseBody
	public RouteVO setMap(int noboard) {
		RouteVO vo = new RouteVO();
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		try {
			vo = dao.selectRoute(noboard);
		}catch(Exception e) {
			System.out.println("레퍼런스 맵 호출 에러" + e.getMessage());
		}
		return vo;
	}
	
	//저장된 루트 List
	@RequestMapping("/mySavedRoute")
	public ModelAndView myRouteBoardList(HttpSession ses) {
		ModelAndView mav = new ModelAndView();
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		try {
			List<RouteCateVO> list = dao.selectMycategory((String)ses.getAttribute("logId"));
			mav.addObject("list",list);
		}catch(Exception e) {
			System.out.println("저장한 루트 카테고리 호출 에러..."+e.getMessage());
		}
		mav.setViewName("route/savedMyRoute");
		return mav;
	}
	
	// 저장한 루트 리스트 페이징
	@RequestMapping("/myroute/paging")
	@ResponseBody
	public MyRoutePagingVO myroutePaging(MyRoutePagingVO vo, HttpSession ses) {
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		try {
			vo.setUserid((String)ses.getAttribute("logId"));
			vo.setTotalRecord(dao.getMyrouteCategoryRecord(vo));
		}catch(Exception e) {
			System.out.println("저장한 루트 페이징 에러 " + e.getMessage());
		}
		return vo;
	}
	
	// 저장한 루트 리스트 가져오기
	@RequestMapping(value="/myroute/selectMyroute")
	@ResponseBody
	public List<RouteVO> selectMyroute(MyRoutePagingVO vo, HttpSession ses){
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		List<RouteVO> list = new ArrayList<RouteVO>();
		
		try {
			vo.setUserid((String)ses.getAttribute("logId"));
			vo.setTotalRecord(dao.getMyrouteCategoryRecord(vo));
			
			list = dao.selectMyroute(vo);
		}catch(Exception e) {
			System.out.println("저장한 루트 리스트 가져오기 에러 " + e.getMessage());
		}
		return list;
	}
	
	// 저장한 루트 지우기
	@RequestMapping("/myroute/excludeList")
	@ResponseBody
	public int excludeList(RouteListVO vo, HttpSession ses) {
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		int result = 0;
		
		try {
			vo.setUserid((String)ses.getAttribute("logId"));
			result = dao.excludeList(vo);
		}catch(Exception e) {
			System.out.println("저장한 루트 리스트 삭제 에러" + e.getMessage());
		}
		return result;
	}
	
	// 저장한 루트 카테고리 이동
	@RequestMapping("/myroute/transferCategory")
	@ResponseBody
	public int transferCategory(RouteListVO vo, HttpSession ses) {
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		int result = 0;
		
		try {
			vo.setUserid((String)ses.getAttribute("logId"));
			result = dao.transferCategory(vo);
		}catch(Exception e) {
			System.out.println("저장한 루트 카테고리 이동 삭제 에러" + e.getMessage());
		}
		return result;
	}
	
	///////////////
	// 루트 비공개 처리 1. 스크랩 여부 체크 
	@RequestMapping("/route/setCloseRoute1")
	@ResponseBody
	public int setCloseRoute1(int noboard, HttpSession ses) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		try {
			if(dao.chkRouteScraped(noboard).equals("T")){
				result = 1;
			}	
		}catch(Exception e) {
			System.out.println("루트 스크랩 체크 에러" + e.getMessage());
		}
		return result;
	}
	
	// 명단 체크 >
	@RequestMapping("/route/setCloseRoute2")
	@ResponseBody
	public List<String> setCloseRoute2(int noboard, HttpSession ses) {
		List<String> result = new ArrayList<String>();
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		String logId = (String)ses.getAttribute("logId");
		try {
			//2. 본인을 제외하고 리스트에 해당 루트를 가지고 있는 사람 명단 가져오기 
			result = dao.selectWhoSavedRoute(noboard, logId);
		}catch(Exception e) {
			System.out.println("루트 비공개 체크 사항 처리 2 에러" + e.getMessage());
			return null;
		}
		return result;
	}
	
	// 루트 비공개 처리
	@RequestMapping("/route/setCloseRoute3")
	@ResponseBody
	public int setCloseRoute3(int noboard, HttpSession ses) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		String logId = (String)ses.getAttribute("logId");
		try {
			// route 비공개 처리
			result = dao.updateRouteClosed(noboard, logId);
		}catch(Exception e) {
			System.out.println("루트 비공개 처리 에러" + e.getMessage());
		}
		return result;
	}
	
	// 루트 공개 처리
	@RequestMapping("/route/setOpenRoute")
	@ResponseBody
	public int setOpenRoute(int noboard, HttpSession ses) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		String logId = (String)ses.getAttribute("logId");
		try {
			// route 비공개 처리
			result = dao.updateRouteOpen(noboard, logId);
		}catch(Exception e) {
			System.out.println("루트 공개 처리 에러" + e.getMessage());
		}
		return result;
	}
	
	// 루트 리스트 저장 취소
	@RequestMapping("/route/revertRoutelist")
	@ResponseBody
	public int revertRoutelist(RouteListVO vo) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		try {
			 result = dao.revertRoutelist(vo);
		}catch(Exception e) {
			System.out.println("루트 저장 취소 처리 오류" + e.getMessage());
		}
		return result;
	}
	
	// 루트 삭제
	@RequestMapping("/route/deleteRoute")
	@ResponseBody
	public int deleteRoute(int noboard, HttpSession ses) {
		int result = 0;
		RouteDaoImp dao = sqlSession.getMapper(RouteDaoImp.class);
		
		try{
			result = dao.deleteRoute(noboard, (String)ses.getAttribute("logId"));
		}catch(Exception e) {
			System.out.println("루트 삭제 에러" + e.getMessage());
		}
		
		return result;
	}
}
