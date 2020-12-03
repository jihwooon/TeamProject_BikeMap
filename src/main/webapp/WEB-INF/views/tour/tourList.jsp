<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" href="/home/css/tourListStyle.css" type="text/css"/>  
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
	$(function(){
		
		//성별 css,체크 변화
		$("#reggender").on('change', function(){
			console.log(111);
			if($(this).is(":checked")){
				$("#whole").css('color','white').css('background-color','rgb(0,176,176)');
				for(var i = 0 ; i < $("input[name=reggender]").length ; i++){
					if(!($("input[name=reggender]").eq(i).prop("checked"))){
						$("input[name=reggender]").eq(i).trigger('click');
					}
				}
			}else{
				$("#whole").css('color','rgb(0,176,176)').css('background-color','rgba(0,176,176,0.2)');
				for(var i = 0 ; i < $("input[name=reggender]").length ; i++){
					if($("input[name=reggender]").eq(i).prop("checked")){
						$("input[name=reggender]").eq(i).trigger('click');
					
					}
				}
			}
		});
		$("input[name=reggender]").on('change', function(){
			var type = $(this).attr("id");
			if($(this).prop("checked")){
				$("#gender"+type).css('color','white').css('background-color','rgb(0,176,176)');
			}else{
				$("#gender"+type).css('color','rgb(0,176,176)').css('background-color','rgba(0,176,176,0.2)');
			}
		});
		
		
		//나이  css,체크 변화
		$("#regage").on('change',function(){
			if($(this).is(":checked")){
				$("#whole2").css('color','white').css('background-color','rgb(0,176,176)');
				for(var i = 0; i < $("input[name=regage]").length ; i++){
					if(!($("input[name=regage]").eq(i).prop("checked"))){
						$("input[name=regage]").eq(i).trigger('click');
					}
				}
			}else{
				$("#whole2").css('color','rgb(0,176,176)').css('background-color','rgba(0,176,176,0.2)');
				for(var i = 0 ; i < $("input[name=regage]").length ; i++){
					if($("input[name=regage]").eq(i).prop("checked")){
						$("input[name=regage]").eq(i).trigger('click');
					}
				}
			}
		});
		$("input[name=regage]").on('change', function(){
			var type = $(this).attr("id");
			if($(this).prop("checked")){
				$("#regage"+type).css('color','white').css('background-color','rgb(0,176,176)');
			}else{
				$("#regage"+type).css('color','rgb(0,176,176)').css('background-color','rgba(0,176,176,0.2)');
			}
		});
		
		$("#departure,#arrive").datepicker({
			changeYear :true,
			changeMonth: true,
			constrainInput:true,
			dateFormat:"yy/mm/dd",
			dayNames:['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			yearRange:"2019:2020"
		});
	
		 movePage(1);
	});	
	
</script>
<div id="mainDivTour">
<div class="tourSearchListDiv">
<form id="searchTour">	
	<div id="dateDiv">
		<div class="labelClass"><label>일&nbsp;정</label></div>
		<div><input type="text" name="departure" placeholder="출발날짜" id="departure" maxlength="10" autocomplete="off"></div>
		<select name="departureeTime" class="departureTime">
			<c:forEach var="i" begin="0" end="24" step="1">
				<option value="${i }">${i }시</option>
			</c:forEach>
		</select>
		<div><label class="label1">~</label></div>
		<div><input type="text" name="arrive"	placeholder="도착날짜" id="arrive" maxlength="10" autocomplete="off"></div>
		<select name="arriveTime" class="arriveTime"  style="margin-top:-29px">
			<c:forEach var="i" begin="0" end="24" step="1">
				<option value="${i }">${i }시</option>
			</c:forEach>
		</select>
	</div>
	
	<div id="placeDiv">
		<div><label class="labelClass">장&nbsp;소</label></div>
		<div><input type="text" name="place" placeholder="출발장소" id="place" autocomplete="off"></div>
		
		<div id="placeAndDistanceDiv">
			<div><label id="distanceLbl">이동거리</label></div>
			<div><input type="text" name="distance" class="distance" maxlength="4" autocomplete="off" ></div>
			<label class="kmLbl1">km</label>
			<div style="margin-top:-10px;"><label class="label2">~</label></div>
			<div><input type="text" name="distance" class="distance" maxlength="4" autocomplete="off" style="margin:-34px 0 0 230px"></div>
			<div class="kmLbl2">km</div>
		</div>	
	</div>
	
	<div id="regGenderDiv">
		<div><label class="labelClass">성&nbsp;별</label></div>
				<div><label id="whole" for="reggender">전&nbsp;체</label></div>
				<div><label id="genderboy" for="boy">남</label></div>
				<div><label id="gendergirl" for="girl">여</label></div>
				
				<div><input type="checkbox" name="reggender" id="reggender"/></div>
				<div><input type="checkbox" name="reggender" id="boy" value="1" /></div>
				<div><input type="checkbox" name="reggender" id="girl" value="2" /></div>
			</div>
	
	<div id="regAgeDiv">
		<div><label class="labelClass">나&nbsp;이</label></div>
		<div><label id="whole2" for="regage">전&nbsp;체</label></div>
		<div><label id="regageten" for="ten">10대</label></div>
		<div><label id="regagetwenty" for="twenty">20대</label></div>
		<div><label id="regagethirty" for="thirty">30대</label></div>
		<div><label id="regageforty" for="forty">40대</label></div>
		<div><label id="regagefiftyOver" for="fiftyOver" style="width:100px">50대 이상</label></div>
		
		<div><input type="checkbox" name="regage" id="regage" /></div>
		<div><input type="checkbox" name="regage" id="ten" value="1" /></div>
		<div><input type="checkbox" name="regage" id="twenty" value="2"/></div>
		<div><input type="checkbox" name="regage" id="thirty" value="3" /></div>
		<div><input type="checkbox" name="regage" id="forty" value="4" /></div>
		<div><input type="checkbox" name="regage" id="fiftyOver" value="5"/></div>
		
	</div>
	<div id="searchAndReset">
		<div><input type="submit" name="search" value="검&nbsp;색" id="search"></div>
		<div><input type="reset" name="reset" value="초기화" id="reset"></div>
	</div>
</form>

	

	<div id="tourSearchTitleDiv"><label id="tourSearchTitleLbl"><b>동행찾기</b></label></div>
	<div  id="paging">
		<ul>
			<!-- 이전 페이지 -->
				<c:if test="${paging.nowPage != 1 }">
					<li><a href="#">Prev</a></li>
				</c:if>
				<c:forEach var="p" begin="${paging.startPageNum }" end="${paging.startPageNum + paging.onePageNumCount -1}">
					<c:if test="${paging.totalPage >= p }">
						<c:if test="${paging.nowPage == p }">
							<li style='color:#00B0B0; font-weight:600;'>${p }</li>
						</c:if>
						<c:if test="${paging.nowPage != p }">
							<li><a href='javascript:movePage(${p })' style='color:black; font-weight:600;'>${p }</a></li>
						</c:if>
					</c:if>
				</c:forEach>
		<!-- 다음 페이지 -->
			<c:if test="${paging.nowPage != paging.totalPage }">
				<li><a href="#">Next</a></li>
			</c:if>
		</ul>
	</div>
	
	<!--  ===========================db작업 / 코스짜기 받아서 수정할 부분 -->
	<div id="tourBoardListDivTop">	
			
	</div>
	
	
		<div id="tourWriteDiv"><input type="button" name="tourWriteBoard" value="글쓰기" onclick="location.href='<%=request.getContextPath()%>/tourWriteForm'"></div>
</div>
</div>
<script>


	function setPaging(vo){
	// 이전 페이징 삭제
	$("#paging").children().remove();
	nowPage = vo.nowPage;
	var tag = "<ul>";
	
	if(vo.nowPage != 1){
		tag += "<li style='margin-right:25px;'><a href='javascript:movePage("+(vo.nowPage -1)+");'>Prev</a></li>";
	}
	
	for(var i = vo.startPageNum ; i <= vo.startPageNum+vo.onePageNumCount -1 ; i++){
		if(vo.totalPage >= i){
			if(vo.nowPage == i){
				tag += "<li style='color:#00B0B0; font-weight:600;'>"+i+"</li>";
			}else{
				tag += "<li><a href='javascript:movePage("+i+")' style='color:black; font-weight:600;'>"+i+"</a></li>";
			}
		}
	}
	
	if(vo.nowPage != vo.totalPage){
		tag += "<li><a href='javascript:movePage("+(vo.nowPage +1)+")'>Next</a></li>"
	}
	
	$("#paging").append(tag);
		
}
	//페이지 이동
	function movePage(p){

		//페이징 변경
		var url ="<%=request.getContextPath()%>/searchTourPaging";
		var params = "nowPage="+p;
		
		console.log(params);
	
		$.ajax({
			 type: 'POST'
			,url:url
			,data:params
			,success:function(result){
				setPaging(result);
			},error:function(){
			console.log("페이징 오류");
		}
	});	
		tourListSelect(p);
}
	
	function tourListSelect(p){
		$("#tourBoardListDivTop").children().remove();
		
		var url ="/home/tourPagingList";
		var params = "nowPage="+p;
		
	
		
		$.ajax({
			url:url
			,data:params
			,success:function(result){
				var $result = $(result);
				var tag="";
				$result.each(function(i,v){
					
					tag += "<div class='tourImgDivClass'>";
					tag += "<div><img src='<%=request.getContextPath()%>/img/img_tour/map.png' class='tourImgClass'/></div>";
					tag += "<div class='blackWrapDiv'>";	
					tag += "<p style='font-size:25px;' class='tourBoardTitle'><b>"+ v.title+"</b></p>";
					tag += "<p style='font-size:20px;' class='tourBoardWrite'>"+v.departure+'~'+v.arrive+"</p>";
					tag += "<hr style='width:200px;'/>";
					tag += "<p style='font-size:40px;' class='tourBoardDay'><b>1Day</b></p>";
					tag += "</div></div>";
				});
				$("#tourBoardListDivTop").html(tag);
			},error:function(){
				console.log("리스트 선택 에러 발생....");
			}
		
		});
		
	}
</script>





