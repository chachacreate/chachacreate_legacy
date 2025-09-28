<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입_회원정보입력</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  
  <!-- Pretendard 폰트 (CDN 연결) -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css" />
  
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            brand: {
              primary: '#2d4739',
              light: '#3d5749',
              lighter: '#5d7769',
              lightest: '#e8ede9'
            }
          },
          fontFamily: {
            'pretendard': ['Pretendard Variable', 'sans-serif']
          }
        }
      }
    }
  </script>
  
  <style>
    body {
      font-family: 'Pretendard Variable', sans-serif;
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    }
    
    /* 타이머 애니메이션 */
    .timer-active {
      animation: pulse 1s infinite;
    }
    
    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.7; }
    }

    /* 향상된 카드 스타일 */
    .form-group {
      background: white;
      border: 2px solid #f1f5f9;
      border-radius: 16px;
      padding: 28px;
      margin-bottom: 20px;
      box-shadow: 
        0 4px 6px -1px rgba(0, 0, 0, 0.05),
        0 2px 4px -1px rgba(0, 0, 0, 0.03);
      transition: all 0.3s ease;
      position: relative;
    }

    .form-group:hover {
      box-shadow: 
        0 10px 15px -3px rgba(0, 0, 0, 0.08),
        0 4px 6px -2px rgba(0, 0, 0, 0.05);
      border-color: #e2e8f0;
      transform: translateY(-1px);
    }

    .form-group label {
      display: block;
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 16px;
      font-size: 15px;
      letter-spacing: -0.025em;
    }

    .form-group input {
      width: 100%;
      padding: 16px 20px;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      font-size: 15px;
      transition: all 0.3s ease;
      background: #fafbfc;
      box-shadow: 
        inset 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .form-group input:focus {
      outline: none;
      border-color: #2d4739;
      background: white;
      box-shadow: 
        0 0 0 4px rgba(45, 71, 57, 0.08),
        inset 0 1px 2px rgba(0, 0, 0, 0.05);
      transform: translateY(-1px);
    }

    .form-group input:hover:not(:focus) {
      border-color: #9ca3af;
      background: white;
    }

    .input-with-button {
      display: flex;
      gap: 16px;
      flex-wrap: wrap;
    }

    .input-with-button input {
      flex: 1;
      min-width: 200px;
    }

    .input-with-button button {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      border: none;
      border-radius: 12px;
      padding: 16px 24px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      white-space: nowrap;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2),
        0 2px 4px -1px rgba(45, 71, 57, 0.1);
    }

    .input-with-button button:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      box-shadow: 
        0 6px 10px -1px rgba(45, 71, 57, 0.25),
        0 4px 6px -1px rgba(45, 71, 57, 0.15);
      transform: translateY(-2px);
    }

    .input-with-button button:active {
      transform: translateY(0px);
      box-shadow: 
        0 2px 4px -1px rgba(45, 71, 57, 0.2);
    }
    
    /* 비밀번호 유효성 검사 */
  
.password-message {
  display: block;
  margin-top: 12px;
  font-size: 13px;
  font-weight: 500;
  padding: 8px 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.password-message.invalid {
  color: #ef4444;
  background: rgba(239, 68, 68, 0.05);
  border: 1px solid rgba(239, 68, 68, 0.2);
}

.password-message.valid {
  color: #22c55e;
  background: rgba(34, 197, 94, 0.05);
  border: 1px solid rgba(34, 197, 94, 0.2);
}

/* 비밀번호 입력 필드 상태별 스타일 */
.form-group input.password-invalid {
  border-color: #ef4444 !important;
  background: rgba(239, 68, 68, 0.03) !important;
}

.form-group input.password-valid {
  border-color: #22c55e !important;
  background: rgba(34, 197, 94, 0.03) !important;
}
    
    /* 우편번호 찾기 버튼 특별 스타일 */
    #postcodeBtn {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      border: 2px solid transparent;
      border-radius: 12px;
      padding: 16px 24px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      white-space: nowrap;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2),
        0 2px 4px -1px rgba(45, 71, 57, 0.1);
    }

    #postcodeBtn:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      color: white;
      box-shadow: 
        0 6px 10px -1px rgba(45, 71, 57, 0.25),
        0 4px 6px -1px rgba(45, 71, 57, 0.15);
      transform: translateY(-2px);
    }

    .signUp-input-area {
      display: flex;
      gap: 16px;
      flex-wrap: wrap;
      margin-top: 16px;
    }

    .signUp-input-area input {
      flex: 1;
      min-width: 200px;
    }

    .signUp-input-area button {
      background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
      color: white;
      border: none;
      border-radius: 12px;
      padding: 16px 24px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      white-space: nowrap;
      box-shadow: 
        0 4px 6px -1px rgba(107, 114, 128, 0.2),
        0 2px 4px -1px rgba(107, 114, 128, 0.1);
    }

    .signUp-input-area button:hover {
      background: linear-gradient(135deg, #4b5563 0%, #374151 100%);
      box-shadow: 
        0 6px 10px -1px rgba(107, 114, 128, 0.25),
        0 4px 6px -1px rgba(107, 114, 128, 0.15);
      transform: translateY(-2px);
    }

    .rrn-box {
      display: flex;
      align-items: center;
      gap: 16px;
      padding: 8px;
      background: #f8fafc;
      border-radius: 12px;
      border: 2px solid #f1f5f9;
    }

    .rrn-box input {
      flex: 1;
      margin: 0;
      background: white;
    }

    .rrn-box span {
      font-size: 20px;
      font-weight: bold;
      color: #6b7280;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    .type-desc {
      background: linear-gradient(135deg, #e8ede9 0%, #f0f4f1 100%);
      padding: 20px;
      border-radius: 12px;
      font-size: 14px;
      color: #4b5563;
      line-height: 1.6;
      margin-bottom: 20px;
      border: 2px solid rgba(45, 71, 57, 0.1);
      box-shadow: 
        inset 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .user-types {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }

    .type-button {
      padding: 20px;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      background: white;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-align: center;
      box-shadow: 
        0 2px 4px -1px rgba(0, 0, 0, 0.05);
    }

    .type-button.active {
      border-color: #2d4739;
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2),
        0 2px 4px -1px rgba(45, 71, 57, 0.1);
      transform: translateY(-2px);
    }

    .type-button:hover:not(.active) {
      border-color: #2d4739;
      color: #2d4739;
      background: #f8fafc;
      box-shadow: 
        0 4px 6px -1px rgba(0, 0, 0, 0.08);
      transform: translateY(-1px);
    }

    .form-buttons {
      display: flex;
      gap: 16px;
      margin-top: 40px;
    }

    .form-buttons button {
      flex: 1;
      padding: 20px;
      border-radius: 12px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      border: none;
      font-size: 16px;
      letter-spacing: -0.025em;
    }

    .form-buttons .cancel {
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      color: #6b7280;
      border: 2px solid #e5e7eb;
      box-shadow: 
        0 2px 4px -1px rgba(0, 0, 0, 0.05);
    }

    .form-buttons .cancel:hover {
      background: linear-gradient(135deg, #e5e7eb 0%, #d1d5db 100%);
      color: #374151;
      box-shadow: 
        0 4px 6px -1px rgba(0, 0, 0, 0.08);
      transform: translateY(-2px);
    }

    .form-buttons .submit {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2),
        0 2px 4px -1px rgba(45, 71, 57, 0.1);
    }

    .form-buttons .submit:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      box-shadow: 
        0 6px 10px -1px rgba(45, 71, 57, 0.25),
        0 4px 6px -1px rgba(45, 71, 57, 0.15);
      transform: translateY(-2px);
    }

    .signUp-message {
      display: block;
      margin-top: 12px;
      font-size: 13px;
      color: #ef4444;
      font-weight: 500;
      padding: 8px 12px;
      border-radius: 8px;
      background: rgba(239, 68, 68, 0.05);
    }

    .signUp-message.confirm {
      color: #22c55e;
      background: rgba(34, 197, 94, 0.05);
    }

    /* 메인 컨테이너 향상 */
    .max-w-4xl {
      box-shadow: 
        0 20px 25px -5px rgba(0, 0, 0, 0.05),
        0 10px 10px -5px rgba(0, 0, 0, 0.02);
      border-radius: 20px;
      overflow: hidden;
    }

    /* 헤더 향상 */
    .bg-brand-primary {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      position: relative;
    }

    .bg-brand-primary::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><pattern id="grain" width="100" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="%23ffffff" opacity="0.05"/><circle cx="30" cy="5" r="0.5" fill="%23ffffff" opacity="0.03"/><circle cx="70" cy="15" r="0.8" fill="%23ffffff" opacity="0.04"/></pattern></defs><rect width="100" height="20" fill="url(%23grain)"/></svg>');
      opacity: 0.1;
    }

    /* 반응형 조정 */
    @media (max-width: 640px) {
      .input-with-button,
      .signUp-input-area {
        flex-direction: column;
      }

      .input-with-button input,
      .signUp-input-area input {
        min-width: auto;
      }

      .user-types {
        grid-template-columns: 1fr;
      }

      .form-buttons {
        flex-direction: column;
      }

      .rrn-box {
        flex-direction: column;
        align-items: stretch;
        gap: 12px;
      }

      .rrn-box span {
        text-align: center;
      }

      .form-group {
        padding: 20px;
        margin-bottom: 16px;
      }
    }

    /* 포커스 시 레이블 강조 */
    .form-group:focus-within label {
      color: #2d4739;
      transform: scale(1.02);
      transition: all 0.2s ease;
    }

    /* 입력 상태별 시각 피드백 - 제거됨 */
  </style>
</head>
<body class="bg-gray-50 min-h-screen font-pretendard">
  <!-- 컨테이너 -->
  <div class="max-w-4xl mx-auto bg-white shadow-sm">
    
    <!-- 상단 헤더 -->
    <div class="bg-brand-primary text-white py-6 px-4 sm:px-8">
      <div class="flex items-center justify-between relative z-10">
        <h1 class="text-xl sm:text-2xl font-bold">회원가입하기</h1>
        <div class="w-8 h-8 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
          <span class="text-sm font-medium">2</span>
        </div>
      </div>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="p-4 sm:p-8">
      
      <!-- 진행 단계 표시 -->
      <div class="mb-8">
        <div class="flex items-center justify-between relative">
          <!-- 진행바 배경 -->
          <div class="absolute top-4 left-0 w-full h-1 bg-gray-200 rounded-full"></div>
          <div class="absolute top-4 left-0 w-2/4 h-1 bg-brand-primary rounded-full"></div>
          
          <!-- 단계들 -->
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">01</div>
            <span class="text-xs sm:text-sm text-brand-primary">약관동의</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">02</div>
            <span class="text-xs sm:text-sm font-medium text-brand-primary">회원정보입력</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center text-sm font-medium mb-2">03</div>
            <span class="text-xs sm:text-sm text-gray-500">완료</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center text-sm font-medium mb-2">04</div>
            <span class="text-xs sm:text-sm text-gray-500">판매자정보입력</span>
          </div>
        </div>
      </div>

      <!-- 회원가입 입력 폼 -->
      <div class="register-wrapper max-w-2xl mx-auto">
        <h2 class="text-xl sm:text-2xl font-bold text-gray-800 mb-8 text-center">회원님의 정보를 입력해주세요</h2>

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
          </div>

          <div class="form-group">
  <label>* 비밀번호(영문/숫자/특수문자 포함 8자 이상)</label> 
  <input type="password" id="passwordInput" placeholder="내용을 입력하세요" required>
  <span class="password-message" id="passwordMessage" style="display: none;"></span>
</div>

<div class="form-group">
  <label>* 비밀번호 확인</label> 
  <input type="password" id="passwordInputChk" placeholder="내용을 입력하세요" required>
  <span class="password-message" id="passwordCheckMessage" style="display: none;"></span>
</div>

          <div class="form-group">
            <label>* 사용자 이름</label> 
            <input id="memberName" type="text" placeholder="내용을 입력하세요">
          </div>

          <div class="form-group">
            <label>* 휴대전화번호(01#-####-####)</label> 
            <input id="memberPhone" type="text" placeholder="내용을 입력하세요">
          </div>

          <div class="form-group">
            <label>* 주민등록번호</label>
            <div class="rrn-box">
              <input id="jumin-prefix" type="text" maxlength="6" placeholder="앞 6자리"> 
              <span>-</span>
              <input id="jumin-suffix" type="password" maxlength="7" placeholder="뒤 7자리">
            </div>
          </div>

          <div class="form-group">
            <label>* 주소 입력</label>
            <div class="input-with-button">
              <input type="button" id="postcodeBtn" value="우편번호 찾기">
            </div>
            <div style="margin-top: 16px; display: flex; gap: 16px; flex-wrap: wrap;">
              <input type="text" id="sample6_postcode" placeholder="우편번호" readonly="readonly" style="flex: 1; min-width: 120px;">
              <input type="text" id="sample6_address" placeholder="주소" readonly="readonly" style="flex: 2; min-width: 200px;">
            </div>
            <div style="margin-top: 16px;">
              <input type="text" id="sample6_detailAddress" placeholder="상세주소">
              <input type="hidden" id="sample6_extraAddress" placeholder="참고항목">
            </div>
          </div>

          <div class="form-group">
            <label>* 회원유형선택</label>
            <p class="type-desc">
              판매자 선택 시 판매자 가입단계로 이동됩니다.<br>판매자 선택 시에도 구매가 가능하며, 추후 판매자 가입도 가능합니다.
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
</body>
</html>

  <!-- 스크립트: 모두 동의 시 각 항목 자동 체크 -->
<script>
	/*유효성 검사 진행 여부 확인용 객체*/
	// => 모든 value가 true인 경우만 회원가입 진행
	const checkObj = {
		"memberEmail": false,
	      "memberPwd": false,
	      "memberPwdCheck": false,
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
	        url: contextPath + "/legacy/auth/join/email",
	        type: "GET",
	        data: { email: email },
	        success: function(result) {
	            if (result > 0) {
	            	alert("이메일을 전송했습니다. 이메일 확인 후 인증번호를 입력해주세요.");
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
	            url: contextPath + "/legacy/auth/join/otp",
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
	  // 비밀번호 검사 부분을 다음과 같이 수정
$('input[type=password]').eq(0).on('input', function() {
  const pwd = $(this).val();
  const isValid = validatePassword(pwd);
  const messageEl = $('#passwordMessage');
  
  checkObj.memberPwd = isValid;
  
  if (pwd.length > 0) { // 입력이 있을 때만 메시지 표시
    messageEl.show();
    
    if (isValid) {
      $(this).removeClass('password-invalid').addClass('password-valid');
      messageEl.removeClass('invalid').addClass('valid');
      messageEl.text('사용 가능한 비밀번호입니다.');
    } else {
      $(this).removeClass('password-valid').addClass('password-invalid');
      messageEl.removeClass('valid').addClass('invalid');
      messageEl.text('영문/숫자/특수문자 포함 8자 이상 입력해주세요.');
    }
  } else {
    messageEl.hide();
    $(this).removeClass('password-valid password-invalid');
  }
});

$('input[type=password]').eq(1).on('input', function() {
  const pwd1 = $('input[type=password]').eq(0).val();
  const pwd2 = $(this).val();
  const isMatch = pwd1 === pwd2;
  const messageEl = $('#passwordCheckMessage');
  
  checkObj.memberPwdCheck = isMatch;
  
  if (pwd2.length > 0) { // 입력이 있을 때만 메시지 표시
    messageEl.show();
    
    if (isMatch) {
      $(this).removeClass('password-invalid').addClass('password-valid');
      messageEl.removeClass('invalid').addClass('valid');
      messageEl.text('비밀번호가 일치합니다.');
    } else {
      $(this).removeClass('password-valid').addClass('password-invalid');
      messageEl.removeClass('valid').addClass('invalid');
      messageEl.text('비밀번호가 일치하지 않습니다.');
    }
  } else {
    messageEl.hide();
    $(this).removeClass('password-valid password-invalid');
  }
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
	      $('#passwordInput').focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberPwdCheck) {
	      alert("🔑 비밀번호와 비밀번호 확인이 다릅니다.");
	      $('#passwordInputChk').focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberName) {
	      alert("👤 이름을 입력해주세요.");
	      $('#memberName').focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberPhone) {
	      alert("📱 휴대폰 번호를 정확히 입력해주세요. 예: 010-1234-5678");
	      $('#memberPhone').focus();
	      e.preventDefault();
	      return;
	    }
	    if (!checkObj.memberRegi) {
	      alert("🆔 주민등록번호 앞 6자리와 뒤 7자리를 올바르게 입력해주세요.");
	      if (!/^\d{6}$/.test($rrnFront.val())) {
	    	 $('#jumin-prefix').focus();
	      } else {
	    	 $('#jumin-suffix').focus();
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
	    		"member":{email: memberEmail,
	    		      password: memberPwd,
	    		      name: memberName,
	    		      phone: memberPhone,
	    		      registrationNumber: memberRegi},
   		      "memberAddress":{
   		    	postNum: postNum,
   		    	addressRoad: addressRoad,
   		    	addressDetail : addressDetail,
   		    	addressExtra: addressExtra,
   		    	isDefault:true
	    		}
	    };
	
	    console.log({
   		    	postNum: postNum,
   		    	addressRoad: addressRoad,
   		    	addressDetail : addressDetail,
   		    	addressExtra: addressExtra,
   		    	isDefault:true
	    		});
	    // 버튼이 active 된 것의 값을 찾음
	    const selectedType = document.querySelector('.type-button.active');
	    const userType = selectedType?.dataset.type;
	    // AJAX POST 요청
	    $.ajax({
	    	  url: '/api/auth/join',
	    	  type: 'POST',
	    	  contentType: 'application/json',
	    	  data: JSON.stringify(data),
	    	  success: function(response, textStatus, xhr) {
	    	    if (xhr.status === 201 || response?.status === 201) {
	    	      alert($('#memberName').val()+'님 회원가입을 축하합니다');
	    	      const logindata = {
	    	    		    "email": memberEmail,
	    	    		    "password": memberPwd
	    	    		}
	    	      $.ajax({
	    	          url: '/api/auth/login',
	    	          type: 'POST',
	    	          contentType: 'application/json',
	    	          data: JSON.stringify(logindata),
	    	          xhrFields: { withCredentials: true }, // 쿠키 포함
	    	          success: function(loginResponse, textStatus, xhr) {
	    	              if (xhr.status === 200 && loginResponse?.status === 200) {
	    	                  localStorage.setItem('accessToken', loginResponse.data.accessToken);

	    	                  // Legacy 서버에도 세션 저장
	    	                  $.ajax({
	    	                      url: '/legacy/auth/loginSuccess',
	    	                      type: "POST",
	    	                      contentType: 'application/json',
	    	                      data: JSON.stringify({ 
	    	                      	memberId:loginResponse.data.login.id,
	    	                      	memberEmail:loginResponse.data.login.email,
	    	                      	memberName:loginResponse.data.login.name,
	    	                      }),
	    	                      success: function(legacyResponse, status, xhrr) {
	    	                          if (xhrr.status === 200) {
	    	                              console.log("Legacy 세션 저장 성공:", legacyResponse);
	    	                              
	    	                              if (userType === 'buyer') {
	    	            	    	    	  window.location.href = contextPath + '/auth/join/complete';
	    	            	    	    	} else if (userType === 'seller') {
	    	            	    	    	  window.location.href = contextPath + '/auth/join/seller';
	    	            	    	    	}
	    	                              
	    	                          } else {
	    	                              alert(legacyResponse?.message || 'Legacy 로그인 실패');
	    	                          }
	    	                      },
	    	                      error: function(xhrr, status, error) {
	    	                          alert('Legacy 서버 오류: ' + (xhrr.responseText || error));
	    	                      }
	    	                  });
	    	                  console.log('자동 로그인 성공');
	    	              } else {
	    	                  alert('자동 로그인 실패');
	    	              }
	    	          },
	    	          error: function(xhr, status, error) {
	    	              alert('서버 오류: ' + (xhr.responseText || error));
	    	          }
	    	      });
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
