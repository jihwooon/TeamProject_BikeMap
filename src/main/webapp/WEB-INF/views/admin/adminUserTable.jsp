<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="nowDate" />  

<!-- Page Content -->



<%
	String pagefile = request.getParameter("page");
	if(pagefile == null){//처음보여주는 페이지는 회원관리 페이지
		pagefile="userTable";
	}
	
	//dao 선언
	//총레코드수
	int totalRecord = 30;//총레코드수
	int onePageRecord = 5;//한페이지당 출력할 레코드 수
	int nowPage = 1;//현재페이지 번호 
	int totalPage = 0;//총페이지 수
	int onePageNum = 5;//한번에 표시할 페이지 수
	int startPage = 1; //페이지 번호의 시작번호
	//
	//-----------------------------------------------
	//현재페이지 정보 구하기
	String nowPageStr = request.getParameter("nowPage");
	if(nowPageStr != null){
		nowPage = Integer.parseInt(nowPageStr);
	}
	//총페이지 수 계산하기 
	totalPage = (int)Math.ceil(totalRecord/(double)onePageRecord);
	//페이지 번호의 시작번호 구하기
	startPage = ((nowPage-1)/onePageNum*onePageNum)+1;
	
	//전체레코드 구하기 페이지별 변경
	//List<FreeboardVO> list = dao.getAllRecord(nowPage, onePageRecord, totalPage, totalRecord);
	

%>
<script>

$(document).ready(function() {
    $('#reportMsg').on('keyup', function() {
        if($(this).val().length > 250) {//varchar500이므로...
            $(this).val($(this).val().substring(0, 250));
        }
    });
});

</script>


	<!-- /Page Sidebar -->
	
	<!-- Page Content -->
	<div class="adminContent">
		<form>
		    <input type="hidden" name="searchFiled" value="${pageVO.searchFiled }" /><!-- //검색조건 -->
   	 		<input type="hidden" name="searchValue" value="${pageVO.searchValue }" /><!-- //검색어 -->
		<select name="choice" id="adminSelect">
			<option value="userid" selected>회원 아이디</option>
			<option value="username">회원 이름</option>	 
		</select>
	
			<input type="text" name="searchWord" id="userSearchWord"  class="searchText" maxlength="20" placeholder="검색어 입력"/>
			<input type="submit" name="search" id="searchBtn" value="검색" class="mint_Btn" style="width:50px; height:30px"/>
		
		<div class="adminTable">
				<h1 class="adminListHead">회원관리</h1>
				<ul id="userList">
							<li>번호</li>
							<li>아이디</li>
							<li>이름</li>
							<li>성별</li>
							<li>나이</li>
							<li>모임횟수</li>
							<li>좋아요</li>
							<li>정지여부</li>
							<li>정지기간</li>
							<!-- DB작업완료 후 for문 생성 -->
							<c:forEach items="${list}" var="vo" varStatus="status">
								<li>${vo.rownum}</li>
								<li id="contents" ><a href="javascript:userPopupOpen();">${vo.userid }</a></li>
								<li>${vo.username}</li>
								<li>
									<c:if test="${vo.gender=='M'}">
										남
									</c:if>
									<c:if test="${vo.gender=='F'}">
										여
									</c:if>
								</li>
								<li>${vo.birth}세</li>
								<li>${vo.tourcnt}회</li>
								<li>${vo.heart}회</li>
								<li style="color:red">
									<c:if test="${vo.endday==null||vo.endday}"><!-- endday가 없을때, 정지기간이 지났을때 정지 버튼이 생긴다.  -->
										<input type="button" name="userBanned" onclick="javascript:suspendPopupOpen('${vo.userid}');" id="suspendBtn"/>
									</c:if>
									<c:if test="${vo.endday!=null}">
										<input type="button" name="userBannedEdit" onclick="javascript:suspendEditPopupOpen('${vo.userid}')" id="suspendEditBtn"/>
									</c:if>
							
								</li>
								<li style="color:red">~${vo.endday}</li>
							</c:forEach>
					</ul>
					   
				
				    <!--Popup Start -->
				    <div id="userlayer" class="layerpop"
				        style="width: 200px; height: 300px;">
				        <article class="layerpop_area">
				        <div class="title" style="padding:15px; border-bottom:2px solid #00B0B0">회원정보</div>
				        <a href="javascript:userPopupClose();" class="layerpop_close"
				            id="userlayerbox_close"></a> <br/>
				        <div class="content">
				       	hong1234<br/>
				       	가입 : 2020.07.24<br/>
				        신고횟수 : 10회<br/>
				        <div id="pop1_IsStop">정지여부 : <span style="font-color:red">정지중</span></div>
				        <div id="pop1_StopTime">정지지간 : <span style="font-color:red">2020.11.14</span><br/></div>
				        <div style="border-bottom:2px solid #00B0B0; padding-bottom:10px">
					        <input type="button" name="userBanned" value="정지하기" onclick="javascript:suspendPopupOpen();" class="red_Btn"/>
					        <input type="button" name="userPage" value="회원페이지">
				       </div>
				        </div>
				        </article>
				    </div>
				    
				    
				</div>
				<!-- Page Content -->
				<div id="paging">
					<ul>
						<!-- 이전페이지 -->
						<li>
							<%if(nowPage==1){ %>
							◀
							<%}else{ %>
								<a href="/home/adminUser?nowPage=<%=nowPage-1 %>">◀</a>
							<%} %>
						</li>
						<% for(int p=startPage; p<startPage+onePageNum; p++){ 
							if(p<=totalPage){
								if(p==nowPage){
						 %>
							<li>
								<a href="/home/adminUser?nowPage=<%=p %>"style="color:rgb(0,176,176);"><%=p %></a>
							</li>
						<%} else {%>
						<li>
							<a href="/home/adminUser?nowPage=<%= p%>"><%=p %></a>
					
						</li>
						<%}
						}//if
					}//for%>
					<li>
						<%if(nowPage<totalPage){ //다음페이지가 없을 경우
						%>
							<a href="/home/adminUser?nowPage=<%=nowPage+1 %>">▶</a>
						<%} %>
					</ul>
					
						
				</div><!-- paging -->
				</form><!-- searchForm -->
			</div><!-- adminContent -->
			
			<!-- suspend popup -->
			<div id="userSuspend" class="layerpop"
				    	style="width:330px;height:300px;">
				    	
				    	<form action="<%=request.getContextPath()%>/adminUser/userSuspendOk" method="POST">
				    	<input type="hidden" name="userid" id="userid" value=""/><!-- DB쪽 보낼데이터 -->
					    	<article class="layerpop_area">
					    	<div class="title">회원 정지 설정</div>
					    	<a href="javascript:suspendPopupClose();" class="layerpop_close"
					    		id="suspendlayerbox_close"></a><br/>
					    	<div id="supspendDiv">
						    	<div class="pop2Row"> 
						    		<span class="pop2Left">정지 기간</span> <input type="number" id="suspendTime" name="endday" min="0" max="90"/>일
						    		<input type="button" name="30days" value="30" class="mint_Btn" onclick="change_suspendTime(this.value)"/>
						    		<input type="button" name="60days" value="60" class="mint_Btn" onclick="change_suspendTime(this.value)"/>
						    		<input type="button" name="90days" value="90" class="mint_Btn" onclick="change_suspendTime(this.value)"/>
						    	</div>
						    	<div class="pop2Row"><span class="pop2Left">사유</span><span id="spUserid">홍길동</span>회원님은 <span id="spReportNum">10회</span>
						    	이상 신고 접수되어 아래와 같이 서비스 이용이 제한되었습니다.
						    	</div>
						    	<div>
						    		<span class="pop2Left">메세지</span> 
						    		<textarea cols="30" rows="6" id="reportMsg" style="overflow:hidden" name="cause">
						    			이용정지 관련 문의가 있으시면 아래 1:1 문의하기 버튼을 클릭하여 고객센터로 문의해 주시기 바랍니다.
						    		</textarea>
								</div>
						    	<input type="submit" value="등록"/>
					    	</div>
					    	</article>
				    	</form>
			</div>
			<!-- suspend POP -->
			
			<!-- suspend Editpopup -->
			<div id="userSuspendEdit" class="layerpop"
				    	style="width:330px;height:300px;">
				    	
				    	<form id="userSuspendEditFrm">
				    	<input type="hidden" name="userid" id="suspendEditUserid" value=""/><!-- DB쪽 보낼데이터 -->
					    
					    	<article class="layerpop_area">
					    	<div class="title">회원 정지 수정</div>
					    	<a href="javascript:suspendEditPopupClose();" class="layerpop_close"
					    		id="suspendlayerbox_close"></a><br/>
					    	<div id="supspendDiv">
					    		<div class="pop2Row">
					    			<input type="radio" name="selSuspend" value="0" >정지해제
					    			<input type="radio" name="selSuspend" value="1" checked="checked">정지기간연장
					    		</div> 
					    		
						    	<div class="pop2Row" id="aa"> 
						    		<span class="pop2Left">정지 기간 변경</span> <input type="number" id="suspendEditTime" name="endday"  placeholder="(-입력시 정지기간 감소)"/>일
						    		<input type="button" name="days" value="3" class="mint_Btn" onclick="change_suspendEditTime(this.value)"/>
						    		<input type="button" name="days" value="6" class="mint_Btn" onclick="change_suspendEditTime(this.value)"/>
						    		<input type="button" name="days" value="9" class="mint_Btn" onclick="change_suspendEditTime(this.value)"/> 
						    	</div>
						    	<div class="pop2Row"><span class="pop2Left">사유</span><span id="spEditUserid"> </span> 회원님은 <span id="spReportNum">10회</span>
						    	이상 신고 접수되어 아래와 같이 서비스 이용이 제한되었습니다.
						    	</div>
						    	<div>
						    		<span class="pop2Left">메세지</span> 
						    		<textarea cols="30" rows="6" id="reportMsg" style="overflow:hidden" name="cause">
						    			이용정지 관련 문의가 있으시면 아래 1:1 문의하기 버튼을 클릭하여 고객센터로 문의해 주시기 바랍니다.
						    		</textarea>
								</div>
						    	<input type="button" value="등록" onclick="javascript:formSubmit()" />
					    	</div>
					    	</article>
				    	</form>
			</div>
			<!-- suspend POP -->
</div><!-- adminhome -->
<!-- Page Content -->
</body>
</html>