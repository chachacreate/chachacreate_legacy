<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>판매자 정보 입력</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  
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

    /* 섹션 박스 스타일 향상 */
    .section-box {
      background: white;
      border: 2px solid #f1f5f9;
      border-radius: 20px;
      padding: 36px;
      margin-bottom: 28px;
      box-shadow: 
        0 6px 20px rgba(0, 0, 0, 0.06),
        0 3px 10px rgba(0, 0, 0, 0.04);
      transition: all 0.3s ease;
      position: relative;
    }

    .section-box:hover {
      box-shadow: 
        0 12px 30px rgba(0, 0, 0, 0.08),
        0 6px 15px rgba(0, 0, 0, 0.06);
      border-color: #e2e8f0;
      transform: translateY(-2px);
    }

    .section-title {
      display: flex;
      align-items: center;
      font-size: 22px;
      font-weight: 800;
      color: #1f2937;
      margin-bottom: 16px;
      letter-spacing: -0.025em;
    }

    .section-title .check {
      color: #22c55e;
      font-size: 28px;
      margin-right: 16px;
      font-weight: bold;
      text-shadow: 0 2px 4px rgba(34, 197, 94, 0.2);
    }

    .section-desc {
      color: #6b7280;
      margin-bottom: 28px;
      font-size: 16px;
      line-height: 1.6;
      font-weight: 500;
    }

    .input-box, .input-box2 {
      width: 100%;
      padding: 16px 20px;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      font-size: 15px;
      margin-bottom: 20px;
      transition: all 0.3s ease;
      background: #fafbfc;
      box-shadow: 
        inset 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .input-box:focus, .input-box2:focus {
      outline: none;
      border-color: #2d4739;
      background: white;
      box-shadow: 
        0 0 0 4px rgba(45, 71, 57, 0.08),
        inset 0 1px 2px rgba(0, 0, 0, 0.05);
      transform: translateY(-1px);
    }

    .input-box:hover:not(:focus), .input-box2:hover:not(:focus) {
      border-color: #9ca3af;
      background: white;
    }

    .input-box:read-only {
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      color: #6b7280;
      border-color: #d1d5db;
    }

    label {
      display: block;
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 12px;
      font-size: 15px;
      letter-spacing: -0.025em;
    }

    select.input-box {
      -webkit-appearance: none;
      -moz-appearance: none;
      appearance: none;
      background-color: #fafbfc;
      background-position: right 16px center;
      background-repeat: no-repeat;
      background-size: 18px;
      padding-right: 50px;
      cursor: pointer;
    }

    select.input-box::-ms-expand {
      display: none;
    }


    /* 계좌 경고 박스 향상 */
    .account-warning-box {
      background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
      border: 2px solid #f59e0b;
      border-radius: 16px;
      padding: 24px;
      margin: 20px 0;
      box-shadow: 
        0 4px 12px rgba(245, 158, 11, 0.15),
        0 2px 6px rgba(245, 158, 11, 0.1);
    }

    .account-warning-title {
      display: flex;
      align-items: center;
      font-weight: 700;
      color: #92400e;
      margin-bottom: 16px;
      font-size: 16px;
    }

    .account-warning-title .check {
      color: #f59e0b;
      margin-right: 12px;
      font-size: 20px;
    }

    .account-warning-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .account-warning-list li {
      color: #92400e;
      padding: 6px 0;
      position: relative;
      padding-left: 24px;
      font-weight: 500;
    }

    .account-warning-list li::before {
      content: '•';
      position: absolute;
      left: 0;
      color: #f59e0b;
      font-weight: bold;
      font-size: 16px;
    }

    /* 계좌 입력 영역 향상 */
    .account-input {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      align-items: start;
      padding: 20px;
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
      border-radius: 16px;
      border: 2px solid #e2e8f0;
    }

    .account-button {
      grid-column: span 2;
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      border: 2px solid transparent;
      border-radius: 12px;
      padding: 16px 28px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      justify-self: center;
      min-width: 220px;
      box-shadow: 
        0 4px 12px rgba(45, 71, 57, 0.2),
        0 2px 6px rgba(45, 71, 57, 0.1);
      font-size: 16px;
    }

    .account-button:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      transform: translateY(-2px);
      box-shadow: 
        0 6px 16px rgba(45, 71, 57, 0.25),
        0 4px 8px rgba(45, 71, 57, 0.15);
    }

    .account-button:active {
      transform: translateY(0px);
      box-shadow: 
        0 2px 8px rgba(45, 71, 57, 0.2);
    }

    /* 버튼 그룹 향상 */
    .button-wrapper {
      display: flex;
      gap: 20px;
      margin-top: 48px;
      justify-content: center;
    }

    .btn-outline {
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      color: #374151;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      padding: 18px 36px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      min-width: 160px;
      font-size: 16px;
      box-shadow: 
        0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .btn-outline:hover {
      background: linear-gradient(135deg, #e5e7eb 0%, #d1d5db 100%);
      border-color: #374151;
      color: #1f2937;
      transform: translateY(-2px);
      box-shadow: 
        0 4px 8px rgba(0, 0, 0, 0.08);
    }

    .btn-primary {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      border: 2px solid transparent;
      border-radius: 12px;
      padding: 18px 36px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      min-width: 160px;
      font-size: 16px;
      box-shadow: 
        0 4px 12px rgba(45, 71, 57, 0.2),
        0 2px 6px rgba(45, 71, 57, 0.1);
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      transform: translateY(-2px);
      box-shadow: 
        0 6px 16px rgba(45, 71, 57, 0.25),
        0 4px 8px rgba(45, 71, 57, 0.15);
    }

    .btn-primary:active {
      transform: translateY(0px);
      box-shadow: 
        0 2px 8px rgba(45, 71, 57, 0.2);
    }

    /* 포커스 시 레이블 강조 */
    .section-box:focus-within label {
      color: #2d4739;
      transform: scale(1.02);
      transition: all 0.2s ease;
    }

    /* 반응형 조정 */
    @media (max-width: 768px) {
      .section-box {
        padding: 28px 24px;
      }

      .section-title {
        font-size: 20px;
      }

      .account-input {
        grid-template-columns: 1fr;
        padding: 16px;
      }

      .account-button {
        grid-column: span 1;
        justify-self: stretch;
        min-width: auto;
      }

      .button-wrapper {
        flex-direction: column;
        gap: 16px;
      }

      .btn-outline, .btn-primary {
        width: 100%;
        min-width: auto;
      }
    }

    @media (max-width: 480px) {
      .section-box {
        padding: 24px 20px;
      }

      .section-title {
        font-size: 18px;
        flex-direction: column;
        align-items: flex-start;
        gap: 8px;
      }

      .section-title .check {
        margin-right: 0;
        font-size: 24px;
      }

      .account-warning-box {
        padding: 20px;
      }
    }
  </style>
</head>
<body class="bg-gray-50 min-h-screen font-pretendard">
  <!-- 컨테이너 -->
  <div class="max-w-4xl mx-auto bg-white shadow-sm min-h-screen">
    
    <!-- 상단 헤더 -->
    <div class="bg-brand-primary text-white py-6 px-4 sm:px-8">
      <div class="flex items-center justify-between relative z-10">
        <h1 class="text-xl sm:text-2xl font-bold">회원가입하기</h1>
        <div class="w-8 h-8 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
          <span class="text-sm font-medium">4</span>
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
          <div class="absolute top-4 left-0 w-full h-1 bg-brand-primary rounded-full"></div>
          
          <!-- 단계들 -->
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">01</div>
            <span class="text-xs sm:text-sm text-brand-primary">약관동의</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">02</div>
            <span class="text-xs sm:text-sm text-brand-primary">회원정보입력</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">03</div>
            <span class="text-xs sm:text-sm text-brand-primary">완료</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">04</div>
            <span class="text-xs sm:text-sm font-medium text-brand-primary">판매자정보입력</span>
          </div>
        </div>
      </div>

      <!-- 판매자 정보 입력 폼 -->
      <div class="max-w-3xl mx-auto">
        <h2 class="text-xl sm:text-2xl font-bold text-gray-800 mb-8 text-center">판매자님의 추가 정보를 입력해주세요</h2>

        <form id="sellerinfo" class="seller-container">
          
          <!-- 계좌 등록 섹션 -->
          <section class="section-box">
            <div class="section-title">
              <span class="check">✔</span> 계좌 등록하기
            </div>
            <p class="section-desc">판매수익금으로 입금 받을 계좌를 등록해주세요</p>

            <label for="account-owner">이름</label>
            <input type="text" id="account-owner" class="input-box" 
                   placeholder="로그인 사용자 이름" readonly 
                   value="${sessionScope.loginMember.memberName}"/>

            <label for="bankselect">은행을 선택해 주세요.</label>
            <select id="bankselect" class="input-box">
              <option value="">은행선택</option>
              <option value="004">국민은행</option>
              <option value="020">우리은행</option>
              <option value="088">신한은행</option>
              <option value="003">기업은행</option>
              <option value="023">SC제일은행</option>
              <option value="011">농협은행</option>
              <option value="005">외환은행</option>
              <option value="090">카카오뱅크</option>
              <option value="032">부산은행</option>
              <option value="071">우체국</option>
              <option value="031">대구은행</option>
              <option value="037">전북은행</option>
              <option value="035">제주은행</option>
              <option value="007">수협은행</option>
              <option value="027">씨티은행</option>
              <option value="039">경남은행</option>
            </select>

            <label for="accountnum">계좌번호를 입력해 주세요.</label>

            <!-- 계좌번호 입력 안내 박스 -->
            <div class="account-warning-box">
              <div class="account-warning-title">
                <span class="check">✔</span> <strong>간편결제로 연결할 수 없는 계좌</strong>
              </div>
              <ul class="account-warning-list">
                <li>본인 명의가 아닌 계좌</li>
                <li>가상계좌/적금/펀드/정기예금 등의 계좌</li>
                <li>휴대폰 번호 등으로 만든 평생 계좌번호</li>
                <li>계좌에 문제가 있는 경우 (예: 지급정지 또는 해약된 경우)</li>
              </ul>
            </div>

            <div class="account-input">
              <input type="text" id="accountnum" class="input-box2"
                     placeholder="-없이 계좌번호 입력" />
              <input type="text" id="accountname" class="input-box2" 
                     placeholder="예금주명" readonly>
              <button type="button" class="account-button" id="accountSubmit">계좌 등록하기</button>
            </div>
          </section>

          <!-- 버튼 영역 -->
          <div class="button-wrapper">
            <button type="button" class="btn-outline" onclick="location.href='${cpath}/main'">돌아가기</button>
            <button type="submit" class="btn-primary">등록하기</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</body>
</html>

<script>
$(document).ready(function() {
    // 뒤로가기 방지 및 리다이렉트
    function preventBack() {
        window.history.forward();
        setTimeout(function() {
            window.location.href = '${cpath}/main';
        }, 100);
    }
    
    // 브라우저 뒤로가기 감지
    window.addEventListener('popstate', preventBack);
    
    // 페이지 로드 시 히스토리 조작
    window.history.pushState(null, null, window.location.href);
});
/* 	$(document).ready(function () {
		
		//-----------------텍스트 길이 체크--------------		
		$('.career-text').on('input', function() {
	        const maxLength = 150;
	        const currentLength = $(this).val().length;
	        const charCountText = currentLength + '/' + maxLength;
	        
	        // 같은 부모요소 내의 .char-count에 글자수 업데이트
	        $(this).siblings('.char-count').text(charCountText);

	        // 150자 초과시 자르기 (선택사항)
	        if (currentLength > maxLength) {
	            $(this).val($(this).val().substring(0, maxLength));
	            $(this).siblings('.char-count').text(maxLength + '/' + maxLength);
	        }
	    });

		//-----------------사진 파일 실시간 반영(파일명 기준)--------------		
		
		  $('.upload-placeholder').on('click', function () {
		    $('#fileInput').click();
		  });
		  $('#fileInput').on('change', function (e) {
			  const file = e.target.files[0];
			  if (!file) return;

			  // 허용할 확장자 배열
			  const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];

			  // 파일명에서 확장자 추출 (소문자 변환)
			  const fileName = file.name.toLowerCase();
			  const extension = fileName.split('.').pop();

			  if (!allowedExtensions.includes(extension)) {
			    alert('jpg, jpeg, png, gif 형식의 이미지 파일만 선택할 수 있습니다.');
			    $(this).val('');  // 선택 초기화
			    return;
			  }

			  // 이미지 파일일 때 처리 (기존 미리보기 등)
			  const reader = new FileReader();
			  reader.onload = function (event) {
			    $('.upload-placeholder').html(`<img src="/\${file.name}" style="max-width: 100%; max-height: 100%; object-fit: contain;">`);
			  };
			  reader.readAsDataURL(file);
			});
	}); */
	const checkObj = {
			"accountname": false
		}
	
		$(function() {
			
			function checkmyinfo() {
				const bank_code = $('#bankselect').val();
				const bank_num = $('#accountnum').val();

				if (!bank_code || !bank_num) {
					alert('은행과 계좌번호를 모두 입력해주세요.');
					return;
				}

				$.ajax({
					url : '${cpath}/legacy/common/bank',
					method : 'GET',
					data : {
						bank_code : bank_code,
						bank_num : bank_num
					},
					success : function(res) {
						if (res.bankHolderInfo) {
		                    $('#accountname').val(res.bankHolderInfo);// 예금주명 입력

		                    // account-owner와 비교
		                    const accountOwner = $('#account-owner').val();
		                    if (accountOwner === res.bankHolderInfo) {
		                        checkObj.accountname = true;
								// 은행 선택 비활성화
						        $('#bankselect').prop('disabled', true);
						        // 계좌번호 입력 비활성화
						        $('#accountnum').prop('disabled', true);
		                    } else {
		                        checkObj.accountname = false;
		                        alert('예금주명이 로그인 사용자와 다릅니다.');
		                    }
						} else {
							alert('예금주 정보를 찾을 수 없습니다.');
						}
					},
					error : function(xhr, status, error) {
						console.error('요청 실패:', error);
						alert('예금주 조회 중 오류가 발생했습니다.');
					}
				});
			}

			// 버튼 클릭 시 실행
			$('#accountSubmit').on('click', checkmyinfo);
		});
	
	$(function() {
	    $('#sellerinfo').on('submit', function(e) {
	        e.preventDefault(); // 폼 제출 기본 동작 막기
	        if (!checkObj.accountname) {
	            alert('예금주명이 로그인 사용자 이름과 일치해야 제출할 수 있습니다.');
	        } else {
		        // 폼에서 필요한 데이터 수집
		        // (예: account, accountBank, profileInfo, personalCheck 등)
		        // 여기서는 계좌 정보와 프로필 정보 예시로 작성
	
		        const sellerData = {
		            account: $('#accountnum').val(),
		            accountBank: $('#bankselect option:selected').text(),
		            profileInfo: $('.profile-info-textarea').val() || ''  // 예시, 프로필 텍스트영역 필요 시
		        };
	
		        // 유효성 체크 (예: 계좌번호, 은행명 체크)
		        if (!sellerData.account || !sellerData.accountBank) {
		            alert('계좌번호와 은행명을 입력해 주세요.');
		            return;
		        }
	
		        $.ajax({
		            url: '${cpath}/legacy/auth/join/seller',
		            method: 'POST',
		            contentType: 'application/json',
		            data: JSON.stringify(sellerData),
		            success: function(res) {
		                alert('판매자 정보가 성공적으로 등록되었습니다.');
		                localStorage.removeItem('accessToken')
		                localStorage.setItem('accessToken', res.data.accessToken);
		                window.location.href = '${cpath}/auth/join/complete';
		            },
		            error: function(xhr, status, error) {
		                alert('판매자 정보 등록에 실패했습니다: ' + error);
		            }
		        });
	        }
       });
	});

</script>

</body>
</html>