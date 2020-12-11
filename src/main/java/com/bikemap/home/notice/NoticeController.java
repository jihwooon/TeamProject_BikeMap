package com.bikemap.home.notice;

import java.net.http.HttpRequest;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bikemap.home.regist.RegistDaoImp;

@Controller
public class NoticeController {
	
public SqlSession sqlSession ;
	
	public SqlSession getSqlSession() {
		return sqlSession;
	}
	
	@Autowired
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	@Autowired
	DataSourceTransactionManager transactionManager;
	
	// 메세지 저장하기
	@RequestMapping("/insertNotice")
	@ResponseBody
	public int insertNotice(NoticeVO vo) {
		int result = 0;
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		RegistDaoImp rDao = sqlSession.getMapper(RegistDaoImp.class);
		try {
			if(rDao.idDoubleChk(vo.getUserid())>0) {
				result = dao.insertNotice(vo);
			}
		}catch(Exception e) {
			System.out.println("메세지 입력 에러 " + e.getMessage());
		}
		return result;
	}
	
	// 쪽지 보내기 창 열기
	@RequestMapping("/sendMsg")
	public ModelAndView sendMsg(HttpSession ses){
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("logId", (String)ses.getAttribute(("logId")));
		mav.setViewName("popup/sendMsg");
		return mav;
	}
	
	// 쪽지함 열기
	@RequestMapping("/messageBox")
	public ModelAndView messageBox(){
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("message/messageBox");
		return mav;
	}
	
	// 쪽지함 페이징
	@RequestMapping("/noticePaging")
	@ResponseBody
	public NoticePagingVO noticePaging(NoticePagingVO vo, HttpSession ses) {
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);

		// 로그인 아이디를 입력 받아 받은 메세지 페이징 생성 후 리스트 이동
		vo.setId((String)ses.getAttribute("logId"));
		
		try {
			vo.setTotalRecord(dao.selectMessageRecord(vo));
		}catch(Exception e) {
			System.out.println("쪽지함 페이징 에러 " + e.getMessage());
		}
		return vo;
	}
	
	// 쪽지함 리스트 가져오기
	@RequestMapping("/selectMessage")
	@ResponseBody
	public List<NoticeVO> selectMessage(NoticePagingVO vo, HttpSession ses) {
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		vo.setId((String)ses.getAttribute("logId")); 
		List<NoticeVO> list = new ArrayList<NoticeVO>();
		
		try {
			vo.setTotalRecord(dao.selectMessageRecord(vo));
			list = dao.selectMsgList(vo);
		}catch(Exception e) {
			System.out.println("쪽지함 리스트 호출 에러 " + e.getMessage());
		}
		return list;
	}
	
	// 읽음 처리
	@RequestMapping("/messageRead")
	@ResponseBody
	public int messageRead(int nonotice) {
		int result = 0;
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		
		try {
			result = dao.readMessage(nonotice);
		}catch(Exception e) {
			System.out.println("쪽지 읽음 처리 에러 " + e.getMessage());
		}
		return result;
	}
	
	// 메세지 삭제
	@RequestMapping("/deleteMsg")
	@ResponseBody
	public int deleteMsg(int nonotice) {
		int result = 0;
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		
		try {
			result = dao.deleteMessage(nonotice);
		}catch(Exception e) {
			System.out.println("쪽지 읽음 처리 에러 " + e.getMessage());
		}
		return result;
	}
	
	// 쪽지 크게 읽기
	@RequestMapping(value = "/messageView")
	@ResponseBody
	public NoticeVO messageView(NoticeVO vo) {
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		try {
			vo = dao.messageView(vo);
		}catch(Exception e) {
			System.out.println("쪽지 내용 불러오기 에러 " + e.getMessage());
		}
		return vo;
	}

	//1:1문의사항 페이지 이동
	@RequestMapping("/userQandA")
	public ModelAndView userQandA() {
		ModelAndView mav = new ModelAndView();
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		
		try {
			List<QnaTypeVO> list = dao.selectQnaType();
			mav.addObject("qnatypeList", list);
		}catch(Exception e) {
			System.out.println("문의 유형 선택 에러 " + e.getMessage());
		}
		mav.setViewName("/message/userQandA");
		return mav;
	}
	
	// 문의사항 남기기
	@RequestMapping("/insertQna")
	@ResponseBody
	public int insertQna(QnaVO vo, HttpServletRequest req) {
		int result = 0;
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);
		HttpSession ses = req.getSession();
		
		vo.setUserid((String)ses.getAttribute("logId"));
		vo.setIp(req.getRemoteAddr());
		
		System.out.println(vo.getSubject());
		System.out.println(vo.getContent());
		try {
			result = dao.insertQna(vo);
		}catch(Exception e) {
			System.out.println("문의 사항 남기기 에러 " + e.getMessage());
		}
		return result;
	}
	
	// qna 페이징
	@RequestMapping("/qnaPaging")
	@ResponseBody
	public QnaPagingVO qnaPaging(QnaPagingVO vo, HttpSession ses) {
		NoticeDaoImp dao = sqlSession.getMapper(NoticeDaoImp.class);

		vo.setId((String)ses.getAttribute("logId"));
		
		try {
			vo.setTotalRecord(dao.selectQnaRecord(vo));
		}catch(Exception e) {
			System.out.println("문의사항 페이징 에러 " + e.getMessage());
		}
		return vo;
	}
	
	//나의 문의사항 글보기
	@RequestMapping("/userQandAView")
	public String userQandAView() {
		return "message/userQandAView";
	}

}