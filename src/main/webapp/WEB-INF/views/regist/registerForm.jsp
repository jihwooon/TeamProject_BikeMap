<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" href="/home/css/registerForm.css" type="text/css"/>
 <script src="//code.jquery.com/jquery-1.12.4.js"></script>
 <script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
	$(function(){
		$("#datepicker").datepicker({
			changeYear : true,
			changeMonth : true,
			constraintInput : true,
			dateFormat : "yy-mm-dd",
			dayNames : ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
			dayNamesMin : ['일','월','화','수','목','금','토'],
			monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNames : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			yearRange : "1950:2010"
		});
		
		var idChk = "N";
		var emailChk = "N";
		var regId = /^[A-Za-z]{1}\w{7,11}$/ ;
		var regName = /^[가-힣]{2,5}$/ ;
		
		
		// 아이디 중복 검사 로직
		// 아이디 정규식 체크	
		$("#idChk").click(function(){
			if($("#userid").val()==""){
				toast("아이디를 입력하세요.",1500);
				return false;
			} 
			if(!regId.test($("#userid").val())){
				toast("아이디는 8~12자리\n영문자로 시작하여야 하고, 숫자와 특수문자 _ 만 사용 가능합니다.",1500);
				return false;
			}
			
			var url = "/home/idDoubleChk";
			var data = "userid="+$("#userid").val();
			$.ajax({
				url : url,
				data : data,
				success : function(result){
					if(result == 0){
						idChk = "Y";
						toast("사용 가능한 아이디 입니다.",1500);
					}else{
						toast("이미 사용 중인 아이디입니다.",1500);
					}
				},error : function(){
					console.log("중복 체크 에러");
				}
			});
			return false;
		});
		
		// 아이디 칸 입력 시 중복 체크 여부는 초기화
		$("#userid").keydown(function(){
			idChk = "N";
		});
		
		$("#domainSelect").on({'change' : function(){
			$("#email2").val($("#domainSelect").val());
			emailChk = "N";
		}});
		
		// 이메일 중복 검사 로직	
		$("#emailChk").click(function(){
			if($("#email1").val()=="" || $("#email2").val=="" ){
				toast("이메일을 입력하세요.", 1500);
				return false;
			}
			
			var url = "/home/emailDoubleChk";
			var data = "email="+$("#email1").val()+"@"+$("#email2").val()
			$.ajax({
				url : url,
				data : data,
				success : function(result){
					if(result == 0){
						emailChk = "Y";
						toast("사용 가능한 이메일입니다.", 1500);
					}else{
						toast("이미 등록된 메일 주소입니다.", 1500);
					}
				},error : function(){
					console.log("중복 체크 에러");
				}
			});
			return false;
		});
		
		// 이메일 입력 시 중복 체크 여부는 초기화
		$("#email1").keydown(function(){
			emailChk = "N";
		});		
		$("#email2").keydown(function(){
			emailChk = "N";
		});
		
		// 입력사항 체크
		$("#registerForm").submit(function(){			
			if(idChk != "Y"){
				toast("아이디 중복 검사를 하세요.", 1500);
				return false;
			}
			
			if($("#userpwd").val()==""){
				toast("비밀번호를 입력하세요.", 1500);
				return false;
			}
			
			if($("#userpwdChk").val()==""){
				toast("비밀번호 확인을 입력하세요.", 1500);
				return false;
			}else if($("#userpwd").val() != $("#userpwdChk").val()){
				toast("비밀번호가 일치하지 않습니다.", 1500);
				return false;
			}
			
			if($("#username").val()==""){
				toast("이름을 입력하세요.", 1500);
				return false;
			}else if(!regName.test($("#username").val())){
				toast("이름은 한글로 2~5자 사이로 입력해주세요.", 1500);
				return false;
			}
			
			if(emailChk != "Y"){
				toast("이메일 중복 검사를 하세요.", 1500);
				return false;
			}
			
			if($("#datepicker").val()==""){
				toast("생일을 선택하세요.", 1500);
				return false;
			}
			
			var url = "/home/registerFormOk"
			var data = $("#registerForm").serialize();
			$.ajax({
				type : 'POST',
				url : url,
				data : data,
				success : function(result){
					if(result > 0){
						toast("회원 가입 완료", 1500)
						setTimeout(function(){location.href="/home/registWelcome";},1500);
					} else{
						toast("회원가입에 실패하였습니다.", 1500);
					}
				},error: function(){
					console.log("회원 가입 오류");
				}
			});
			return false;
		});
	});
	
</script>
<div class="registerMainDiv" style='margin-bottom:150px'>
	<form id="registerForm" method="post" action="<%=request.getContextPath()%>/registerFormOk">
		<ul>
			<li class="registerTitle"><label class="registerTitleLbl">회원가입</label></li>
			<li class="registerWriteForm">	
				<div class = "registerFormLblDiv">
					<ul>
						<li>아이디</li>
						<li>비밀번호</li>
						<li>비밀번호 확인</li>
						<li>이  름</li>
						<li>이메일</li>
						<li>성  별</li>
						<li>생년월일</li>
					</ul>
				</div>
			</li>	
			<li id="input">
				<ul>
					<li><input type="text" name="userid" id="userid" class="i1" maxlength="12" size="12" autocomplete="off"/> <input type="button" class="gray_Btn" id="idChk" value="중복검사"/></li>
						<li><span class="reg">&nbsp;&ensp;※ 8~12자 영문(시작)/숫자/_ 사용</span></li>
					<li><input type="password" name="userpwd" id="userpwd" class="i2" maxlength="12" size="20"/></li>
						<li><span class="reg">&ensp;※ 8~12자리 영문/숫자/특수문자 사용</span></li>
					<li><input type="password" name="userpwdChk" id="userpwdChk" class="i2" maxlength="12" size="20"/></li>
						<li><span class="reg">&ensp;</span></li>
					<li><input type="text" name="username" id="username" class="i2" maxlength="5" size="20" autocomplete="off"/></li>
						<li><span class="reg">&ensp;※ 한글로 최대 5자까지 입력</span></li>
					<li><input type="text" name="email1" id="email1" class="i3" size="6" autocomplete="off"/><span class="tlbl"> @ </span><input type="text" id="email2" class="i3" name="email2" size="6" autocomplete="off"/>
					<select id="domainSelect">
						<option value="" selected>직접입력</option>
						<option value="naver.com">naver.com</option>
						<option value="google.com">google.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hotmali.com">hotmail.com</option>
					</select>
					<input type="button" class="gray_Btn" id="emailChk" value="중복검사"/></li>
					<li><span class="reg">※ 이메일은 계정 활성화 및 아이디&비밀번호 찾기 인증 수단으로 사용됩니다.</span></li>
					
					<li><input type="radio"name="gender" id="male" value="1"/><label for="male" class="tlbl2">남 자</label>
						<input type="radio" name="gender" id="female" value="2" checked/><label for="female" class="tlbl2">여 자</label></li>
						<li><span class="reg">&ensp;</span></li>
					<li><input type="text" name="birth" id="datepicker" class="i2" maxlength="10" autocomplete="off"></li>	
						<li><span class="reg">&ensp;※ ex)1980-12-03</span></li>	
				</ul>
			</li>
			<li id="buttons2">
				<input type="submit" class="mint_Btn" value="회원가입"/>
				<input type="reset" class="WMint_Btn" value="다시쓰기"/>
			</li>
		</ul>
	</form>

</div>