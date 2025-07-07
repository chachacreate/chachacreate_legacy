<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입_회원정보입력</title>

<!-- Pretendard 폰트 (CDN 연결) -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css" />
	
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/auth/join/joinInfo.css">
 <script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
  <div class="container">

    <!-- 상단 배너 -->
    <div class="header-banner">
      <div class="header-content">
        <div class="logo-title-wrapper">
          <img class="logo" src="${cpath}/resources/images/logo.png" />
          <div class="page-title">회원가입하기</div>
        </div>
        <img class="header-illustration" src="${cpath}/resources/images/illustration.png" />
      </div>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="main-wrapper">
      <!-- 가입 단계 -->
      <div class="step-indicator">
  <div class="step">
    <div class="step-circle">01</div>
    <div class="step-label">약관동의</div>
  </div>
  <img class="arrow" src="${cpath}/resources/images/arrow-right.svg" />
  <div class="step current">
    <div class="step-circle">02</div>
    <div class="step-label">회원정보입력</div>
  </div>
  <img class="arrow" src="${cpath}/resources/images/arrow-right.svg" />
  <div class="step">
    <div class="step-circle">03</div>
    <div class="step-label">완료</div>
  </div>
  <img class="arrow" src="${cpath}/resources/images/arrow-right.svg" />
  <div class="step">
    <div class="step-circle">04</div>
    <div class="step-label">판매자정보입력</div>
  </div>
</div>

      <!-- 회원가입 입력 폼 -->
			<div class="register-wrapper">
				<h2 class="title">회원님의 정보를 입력해주세요</h2>

				<form id="joinForm">
					<div class="form-group">
						<label>* 아이디(이메일)</label>
						<div class="input-with-button">
							<input type="text" name="memberEmail" id="memberEmail"
								placeholder="아이디(이메일)" maxlength="30" autocomplete="off">
							<button type="button" id="sendAuthKeyBtn">이메일인증</button>
						</div>
						<!-- 인증번호 입력 -->
						<label for="emailCheck"> <span class="required">*</span>
							인증번호
						</label>
						<div class="signUp-input-area">
							<input type="text" name="authKey" id="authKey"
								placeholder="인증번호 입력" maxlength="6" autocomplete="off">

							<button id="checkAuthKeyBtn" type="button">인증하기</button>
						</div>
						<span class="signUp-message" id="authKeyMessage"></span>
						<!-- 인증번호가 일치하지 않습니다 -->
					</div>


					<div class="form-group">
						<label>* 비밀번호(영문/숫자/특수문자 포함 8자 이상)</label> <input type="password"
							placeholder="내용을 입력하세요" required>
					</div>

					<div class="form-group">
						<label>* 비밀번호 확인</label> <input type="password"
							placeholder="내용을 입력하세요" required>
					</div>

					<div class="form-group">
						<label>사용자 이름</label> <input id="memberName" type="text" placeholder="내용을 입력하세요">
					</div>

					<div class="form-group">
						<label>휴대전화번호(01#-####-####)</label> <input id="memberPhone" type="text" placeholder="내용을 입력하세요">
					</div>

					<div class="form-group">
						<label>주민등록번호</label>
						<div class="rrn-box">
							<input id="jumin-prefix" type="text" maxlength="6" placeholder="앞 6자리"> <span>-</span>
							<input id="jumin-suffix" type="password" maxlength="7" placeholder="뒤 7자리">
						</div>
					</div>

					<div class="form-group">
						<label>주소 입력</label>
						<div class="input-with-button">
							<input type="button" id="postcodeBtn" value="우편번호 찾기"><br>
							<input type="text" id="sample6_postcode" placeholder="우편번호"
								readonly="readonly"> <input type="text"
								id="sample6_address" placeholder="주소" readonly="readonly"><br>
							<input type="text" id="sample6_detailAddress" placeholder="상세주소">
							<input type="hidden" id="sample6_extraAddress" placeholder="참고항목">
						</div>
					</div>

					<div class="form-group">
						<label>* 회원유형선택</label>
						<p class="type-desc">
							판매자 선택 시 판매자 가입단계로 이동됩니다.<br>판매자 선택 시에도 구매가 가능하며, 추후 판매자 가입도
							가능합니다.
						</p>
						<div class="user-types">
							<button type="button" class="type-button active" data-type="buyer">구매자</button>
							<button type="button" class="type-button" data-type="seller">판매자</button>
						</div>
					</div>

					<div class="form-buttons">
						<button type="button" class="cancel" onclick="location.href='${cpath}/auth/login'">취소</button>
						<button type="submit" class="submit">다음</button>
					</div>
				</form>
			</div>
      
      
    </div>
  </div>

  <!-- 스크립트: 모두 동의 시 각 항목 자동 체크 -->
<script>
	/*유효성 검사 진행 여부 확인용 객체*/
	// => 모든 value가 true인 경우만 회원가입 진행
	const checkObj = {
		"memberEmail": false,
	      "memberPwd": false,
	      "memberName": false,
	      "memberPhone": false,
	      "memberRegi": false,
	      "addressAll" : false,
	      "addressDetail" : false,
	      "authKey" : false
	}
	
	//----------------소셜로그인 정보를 가지고와 가입되게 변경-----------------------
	  $(document).ready(function() {
		    // JSP EL을 이용해 sessionScope.kakaoemail 값을 JS 변수에 할당
		    var kakaoEmail = "${sessionScope.kakaoemail}";
		    var naverInfo = "${sessionScope.naverInfo}";

		    if (kakaoEmail) {
		      // checkObj가 있으면 true로 설정 (checkObj가 전역객체라고 가정)
		      if (typeof checkObj === "object") {
		        checkObj.memberEmail = true;
		        checkObj.authKey = true;
		      }

		      // memberEmail input에 값 넣고 읽기전용 처리
    		  $("#memberEmail").val(kakaoEmail).prop("readonly", true).css("background-color", "#eee");

		      // 버튼과 입력창 비활성화
		      $("#sendAuthKeyBtn").prop("disabled", true);
		      $("#authKey").prop("disabled", true).css("background-color", "#eee");
		      $("#checkAuthKeyBtn").prop("disabled", true);
		    }
		    if(naverInfo){
		    	naverInfo = JSON.parse(naverInfo.replace(/=/g, '":"').replace(/, /g, '", "').replace(/{/, '{"').replace(/}/, '"}'));
		    	if(typeof checkObj == "object"){
			        checkObj.memberEmail = true;
			        checkObj.authKey = true;
			        checkObj.memberName = true;
			        checkObj.memberPhone = true;
			        checkObj.memberRegi = true;
		    	}
		    	// 주민등록번호 만들기
		    	const birthyear = naverInfo.birthyear;
		        const birthday = naverInfo.birthday;
		        const gender = naverInfo.gender;
		        
		        const yy = birthyear.substring(2);
		        const mmdd = birthday.replace("-", "");
		        const yymmdd = yy + mmdd;
		        
		        // 성별코드 결정
		        let genderCode = "";
		        const yearNum = parseInt(birthyear);
		        if (yearNum >= 2000) {
		            genderCode = (gender.toUpperCase() === "M") ? "3333333" : "4444444";
		        } else {
		            genderCode = (gender.toUpperCase() === "M") ? "1111111" : "2222222";
		        }
		      // 네이버에서 받아온 정보 input에 값 넣고 읽기전용 처리
		      $("#memberEmail").val(naverInfo.email).prop("readonly", true).css("background-color", "#eee");
		      $("#memberName").val(naverInfo.name).prop("readonly", true).css("background-color", "#eee");
		      $("#memberPhone").val(naverInfo.mobile).prop("readonly", true).css("background-color", "#eee");
		      $("#jumin-prefix").val(yymmdd).prop("readonly", true).css("background-color", "#eee");
		      $("#jumin-suffix").val(genderCode).prop("readonly", true).css("background-color", "#eee");
		      
		      // 버튼과 입력창 비활성화
		      $("#sendAuthKeyBtn").prop("disabled", true);
		      $("#authKey").prop("disabled", true).css("background-color", "#eee");
		      $("#checkAuthKeyBtn").prop("disabled", true);
		    }
	});
	
	//----------------------------구매자 판매자 버튼 토글-----------------
	
	const buttons = document.querySelectorAll('.type-button');

	buttons.forEach(button => {
	  button.addEventListener('click', () => {
		  event.preventDefault();
	    // 모든 버튼에서 active 제거
	    buttons.forEach(btn => btn.classList.remove('active'));
	    // 클릭한 버튼에만 active 추가
	    button.classList.add('active');
	  });
	});
	
	
	//----------------------------주소 api 사용----------------------
	$(()=>{
		$('#postcodeBtn').click(function() {
		    new daum.Postcode({
		    	oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var addr = ''; // 주소 변수
	                var extraAddr = ''; // 참고항목 변수

	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    // 조합된 참고항목을 해당 필드에 넣는다.
	                    document.getElementById("sample6_extraAddress").value = extraAddr;
	                
	                } else {
	                    document.getElementById("sample6_extraAddress").value = '';
	                }
		
		                // 우편번호와 주소 정보를 해당 필드에 넣는다.
		                checkObj.addressAll = true;
		                document.getElementById('sample6_postcode').value = data.zonecode;
		                document.getElementById("sample6_address").value = addr;
		                // 커서를 상세주소 필드로 이동한다.
		                document.getElementById("sample6_detailAddress").focus();
		            }
	        }).open();
		});
	});
	//------------------------이메일인증---------------------------
	// 인증번호 발송 관련 변수
	let authTimer;
	let authMin = 4;
	let authSec = 59;
	let tempEmail = ""; // 인증 요청한 이메일 저장
	const authKeyMessage = document.getElementById("authKeyMessage");
	const contextPath = "${cpath}";
	// 이메일 인증 버튼 클릭
	$("#sendAuthKeyBtn").on("click", function() {
		
		if ($("#memberEmail").val().trim() === "") {
	        alert("이메일을 먼저 입력해주세요.");
	        $("#memberEmail").focus();
	        return;
	    }
		
	    authMin = 4;
	    authSec = 59;
	    clearInterval(authTimer); // 기존 타이머 제거
	    checkObj.authKey = false;
	    const email = $("#memberEmail").val();
		if (checkObj.memberEmail == false){
	        alert("이메일 형식이 올바르지 않습니다.");
	        $("#memberEmail").focus();
	        return;
		}
	    $.ajax({
	        url: contextPath + "/sendEmail/signUp",
	        type: "GET",
	        data: { email: email },
	        success: function(result) {
	            if (result > 0) {
	                console.log("인증 번호가 발송되었습니다.");
	                tempEmail = email;
	
	                authKeyMessage.innerText = "05:00";
	                authKeyMessage.classList.remove("confirm");
	
	                // 타이머 시작
	                authTimer = setInterval(() => {
	                    let displayMin = authMin < 10 ? "0" + authMin : authMin;
	                    let displaySec = authSec < 10 ? "0" + authSec : authSec;
	                    authKeyMessage.innerText = `\${displayMin}:\${displaySec}`;
	
	                    if (authMin === 0 && authSec === 0) {
	                        clearInterval(authTimer);
	                        checkObj.authKey = false;
	                        return;
	                    }
	
	                    if (authSec === 0) {
	                        authMin--;
	                        authSec = 60;
	                    }
	
	                    authSec--;
	
	                }, 1000);
	            } else {
	                console.log("인증번호 발송 실패");
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log("이메일 발송 중 에러 발생");
	            console.log(error);
	        }
	    });
	});

	// 인증번호 확인
	$("#checkAuthKeyBtn").on("click", function() {
	    if (authMin > 0 || authSec > 0) {
	        const inputKey = $("#authKey").val();
	
	        $.ajax({
	            url: contextPath + "/sendEmail/checkAuthKey",
	            type: "GET",
	            data: { inputKey: inputKey, email: tempEmail },
	            success: function(result) {
	                if (result > 0) {
	                    clearInterval(authTimer);
	                    authKeyMessage.innerText = "인증되었습니다.";
	                    authKeyMessage.classList.add("confirm");
	                    checkObj.authKey = true;
	                } else {
	                    alert("인증번호가 일치하지 않습니다.");
	                    checkObj.authKey = false;
	                    $("#authKey").focus();
	                }
	            },
	            error: function(xhr, status, error) {
	                console.log("인증번호 확인 중 에러 발생");
	                console.log(error);
	            }
	        });
	    } else {
	        alert("인증 시간이 만료되었습니다. 다시 시도해주세요.");
	        $("#memberEmail").focus();
	    }
	});
	
	//----------------------------------------------- 유효성 검사------------------------------
	$(function() {
	  // 이메일 검사
	  $('#memberEmail').on('input', function() {
	    const email = $(this).val();
	    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	    checkObj.memberEmail = regex.test(email);
	  });

	  const specialChars = `!"#$%&'()*+,-./:;<=>?@[\\]^_\`{|}~`;

		// 특수문자 중 하나 이상 포함 확인용 정규식 패턴 생성
		const specialPattern = new RegExp("[" + specialChars.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') + "]");

		// 비밀번호 유효성 검사 함수
		function validatePassword(pwd) {
		  // 길이 검사
		  if (pwd.length < 8) return false;
	
		  // 영어 포함 (대소문자 상관없이)
		  if (!/[a-zA-Z]/.test(pwd)) return false;
	
		  // 숫자 포함
		  if (!/[0-9]/.test(pwd)) return false;
	
		  // 특수문자 포함
		  if (!specialPattern.test(pwd)) return false;
	
		  return true;
		}
	  // 비밀번호 검사
	  $('input[type=password]').eq(0).on('input', function() {
	    const pwd = $(this).val();
	    checkObj.memberPwd = validatePassword(pwd);
	  });

	  // 사용자 이름 검사 (공백 제외 1자 이상)
	  $('input[placeholder="내용을 입력하세요"]').eq(2).on('input', function() {
	    const name = $(this).val().trim();
	    checkObj.memberName = name.length > 0;
	  });

	// 휴대폰 번호 검사 (하이픈 포함: 010-1234-5678 형식)
	  $('input[placeholder="내용을 입력하세요"]').eq(3).on('input', function() {
		  const phone = $(this).val();
		  const regex = /^01[016789]-\d{3,4}-\d{4}$/;
		  checkObj.memberPhone = regex.test(phone);
		});

	  // 주민등록번호 검사 (앞 6자리 숫자 + 뒤 1자리 숫자)
	  $('.rrn-box input').on('input', function() {
	    const rrnFront = $('.rrn-box input').eq(0).val();
	    const rrnBackFirst = $('.rrn-box input').eq(1).val().charAt(0);
	    const frontValid = /^\d{6}$/.test(rrnFront);
	    const backValid = /^\d$/.test(rrnBackFirst);
	    checkObj.memberRegi = frontValid && backValid;
	  });
	  // 상세주소 입력 시 유효성 검사 (공백 제외 1자 이상 입력)
	  $('#sample6_detailAddress').on('input', function () {
	    const detailAddr = $(this).val().trim();
	    checkObj.addressDetail = detailAddr.length > 0;
	  });
	});
	

	$('#joinForm').on('submit', function(e) {
	    e.preventDefault(); // 폼 기본 제출 막기
	    
	 // 각 항목별 검사 + 포커스 지정
	    if (!checkObj.memberEmail) {
	      alert("📧 이메일을 정확히 입력해주세요.");
	      $('#memberEmail').focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.authKey) {
	      alert("🔐 이메일 인증을 완료해주세요.");
	      $('#authKeyInput').focus(); // 실제 인증코드 입력 input ID가 다를 경우 수정
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberPwd) {
	      alert("🔑 비밀번호는 8자 이상, 영문/숫자/특수문자를 모두 포함해야 합니다.");
	      $passwordInput.focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberName) {
	      alert("👤 이름을 입력해주세요.");
	      $nameInput.focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberPhone) {
	      alert("📱 휴대폰 번호를 정확히 입력해주세요. 예: 010-1234-5678");
	      $phoneInput.focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberRegi) {
	      alert("🆔 주민등록번호 앞 6자리와 뒤 7자리를 올바르게 입력해주세요.");
	      if (!/^\d{6}$/.test($rrnFront.val())) {
	        $rrnFront.focus();
	      } else {
	        $rrnBack.focus();
	      }
	      e.preventDefault();
	      return;
	    }
	    if(!checkObj.addressAll){
	    	alert("주소를 선택해주세요");
	    	$('#sample6_address').focus();
		    e.preventDefault();
		    return;
	    }
	    if(!checkObj.addressDetail){
	    	alert("상세 주소를 작성해주세요");
	    	$('#sample6_detailAddress').focus();
		    e.preventDefault();
		    return;
	    }
	
	    // 각 input 값 가져오기
	    const memberEmail = $('#memberEmail').val();
	    const memberPwd = $('input[type=password]').eq(0).val(); // 첫 번째 비밀번호 input
	    const memberName = $('input[placeholder="내용을 입력하세요"]').eq(2).val(); // 사용자 이름 input (3번째 텍스트 input)
	    const memberPhone = $('input[placeholder="내용을 입력하세요"]').eq(3).val(); // 휴대전화번호 input (4번째 텍스트 input)
	    
	    const postNum = $('#sample6_postcode').val();
	    const addressRoad = $('#sample6_address').val();
	    const addressDetail = $('#sample6_detailAddress').val();
	    const addressExtra = $('#sample6_extraAddress').val();
	    
	    
	    // 주민등록번호 합치기 (앞 6자리 + 뒤 7자리)
	    const rrnFront = $('.rrn-box input').eq(0).val();
	    const rrnBack = $('.rrn-box input').eq(1).val().charAt(0);
	    const memberRegi = rrnFront + "-" + rrnBack;
	
	    // JSON 객체 생성
	    const data = {
	    		"member":{memberEmail: memberEmail,
	    		      memberPwd: memberPwd,
	    		      memberName: memberName,
	    		      memberPhone: memberPhone,
	    		      memberRegi: memberRegi},
   		      "addr":{
   		    	postNum: postNum,
   		    	addressRoad: addressRoad,
   		    	addressDetail : addressDetail,
   		    	addressExtra: addressExtra,
   		    	addressCheck:1
	    		}
	    };
	
	    console.log({
   		    	postNum: postNum,
   		    	addressRoad: addressRoad,
   		    	addressDetail : addressDetail,
   		    	addressExtra: addressExtra,
   		    	addressCheck:1
	    		});
	    // 버튼이 active 된 것의 값을 찾음
	    const selectedType = document.querySelector('.type-button.active');
	    const userType = selectedType?.dataset.type;
	    
	    // AJAX POST 요청
	    $.ajax({
	    	  url: contextPath + '/api/auth/join/userinfo',
	    	  type: 'POST',
	    	  contentType: 'application/json',
	    	  data: JSON.stringify(data),
	    	  success: function(response, textStatus, xhr) {
	    	    if (xhr.status === 201 || response?.status === 201) {
	    	      alert($('#memberName').val()+'님 회원가입을 축하합니다');
	    	      if (userType === 'buyer') {
	    	    	  window.location.href = contextPath + '/auth/join/complete';
	    	    	} else if (userType === 'seller') {
	    	    	  window.location.href = contextPath + '/auth/join/seller';
	    	    	}
	    	    } else {
	    	      // API 응답 형식은 맞지만 실패한 경우
	    	      alert('회원가입 실패: ' + (response?.message || '알 수 없는 오류'));
	    	    }
	    	  },
	    	  error: function(xhr, status, error) {
	    	    alert('전송 실패: ' + (xhr.responseText || error));
	    	  }
	    	});
	  });
	</script>


</body>
</html>
