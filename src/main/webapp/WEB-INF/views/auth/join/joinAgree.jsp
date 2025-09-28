
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입_약관동의</title>
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

    /* 전체 동의 박스 향상 */
    .agreement-all {
      background: linear-gradient(135deg, #e8ede9 0%, #f0f4f1 100%);
      border: 2px solid #2d4739;
      border-radius: 16px;
      padding: 28px;
      box-shadow: 
        0 6px 10px -1px rgba(45, 71, 57, 0.15),
        0 4px 6px -1px rgba(45, 71, 57, 0.1);
      transition: all 0.3s ease;
    }

    .agreement-all:hover {
      box-shadow: 
        0 10px 15px -3px rgba(45, 71, 57, 0.2),
        0 6px 10px -2px rgba(45, 71, 57, 0.15);
      transform: translateY(-2px);
    }

    /* 개별 약관 박스 향상 */
    .terms-card {
      background: white;
      border: 2px solid #f1f5f9;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 
        0 4px 6px -1px rgba(0, 0, 0, 0.05),
        0 2px 4px -1px rgba(0, 0, 0, 0.03);
      transition: all 0.3s ease;
    }

    .terms-card:hover {
      box-shadow: 
        0 10px 15px -3px rgba(0, 0, 0, 0.08),
        0 4px 6px -2px rgba(0, 0, 0, 0.05);
      border-color: #e2e8f0;
      transform: translateY(-2px);
    }

    .terms-header {
      padding: 24px 28px;
      border-bottom: 2px solid #f1f5f9;
      background: linear-gradient(135deg, #fafbfc 0%, #f8fafc 100%);
    }

    .terms-content {
      padding: 24px 28px;
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
      max-height: 160px;
      overflow-y: auto;
      border: 1px solid rgba(0, 0, 0, 0.05);
    }

    /* 커스텀 체크박스 스타일 향상 */
    .custom-checkbox {
      appearance: none;
      width: 24px;
      height: 24px;
      border: 2px solid #d1d5db;
      border-radius: 6px;
      background: white;
      cursor: pointer;
      position: relative;
      transition: all 0.3s ease;
      box-shadow: 
        0 2px 4px -1px rgba(0, 0, 0, 0.05);
    }

    .custom-checkbox:hover {
      border-color: #2d4739;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.1);
      transform: translateY(-1px);
    }
    
    .custom-checkbox:checked {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      border-color: #2d4739;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2);
    }
    
    .custom-checkbox:checked::after {
      content: '✓';
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: white;
      font-size: 14px;
      font-weight: bold;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }
    
    /* 커스텀 라디오 버튼 스타일 향상 */
    .custom-radio {
      appearance: none;
      width: 20px;
      height: 20px;
      border: 2px solid #d1d5db;
      border-radius: 50%;
      background: white;
      cursor: pointer;
      position: relative;
      transition: all 0.3s ease;
      box-shadow: 
        0 2px 4px -1px rgba(0, 0, 0, 0.05);
    }

    .custom-radio:hover {
      border-color: #2d4739;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.1);
      transform: translateY(-1px);
    }
    
    .custom-radio:checked {
      border-color: #2d4739;
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2);
    }
    
    .custom-radio:checked::after {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 8px;
      height: 8px;
      background: white;
      border-radius: 50%;
      box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    /* 버튼 스타일 향상 */
    .btn-cancel {
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      color: #6b7280;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      padding: 16px 24px;
      font-weight: 700;
      font-size: 16px;
      text-decoration: none;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      box-shadow: 
        0 2px 4px -1px rgba(0, 0, 0, 0.05);
    }

    .btn-cancel:hover {
      background: linear-gradient(135deg, #e5e7eb 0%, #d1d5db 100%);
      color: #374151;
      box-shadow: 
        0 4px 6px -1px rgba(0, 0, 0, 0.08);
      transform: translateY(-2px);
    }

    .btn-next {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      border: 2px solid transparent;
      border-radius: 12px;
      padding: 16px 24px;
      font-weight: 700;
      font-size: 16px;
      text-decoration: none;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      box-shadow: 
        0 4px 6px -1px rgba(45, 71, 57, 0.2),
        0 2px 4px -1px rgba(45, 71, 57, 0.1);
    }

    .btn-next:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      color: white;
      box-shadow: 
        0 6px 10px -1px rgba(45, 71, 57, 0.25),
        0 4px 6px -1px rgba(45, 71, 57, 0.15);
      transform: translateY(-2px);
    }

    /* 라벨 텍스트 향상 */
    .terms-label {
      font-weight: 600;
      color: #1f2937;
      letter-spacing: -0.025em;
    }

    .terms-required {
      color: #ef4444;
      font-weight: 700;
    }

    .radio-label {
      font-weight: 500;
      transition: all 0.2s ease;
    }

    .radio-label:hover {
      color: #2d4739;
    }

    /* 약관 내용 스크롤바 스타일 */
    .terms-content::-webkit-scrollbar {
      width: 6px;
    }

    .terms-content::-webkit-scrollbar-track {
      background: #f1f5f9;
      border-radius: 3px;
    }

    .terms-content::-webkit-scrollbar-thumb {
      background: #cbd5e1;
      border-radius: 3px;
    }

    .terms-content::-webkit-scrollbar-thumb:hover {
      background: #94a3b8;
    }

    /* 반응형 조정 */
    @media (max-width: 640px) {
      .agreement-all,
      .terms-header,
      .terms-content {
        padding: 20px;
      }

      .custom-checkbox {
        width: 22px;
        height: 22px;
      }

      .custom-radio {
        width: 18px;
        height: 18px;
      }

      .btn-cancel,
      .btn-next {
        padding: 14px 20px;
        font-size: 15px;
      }
    }
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
          <span class="text-sm font-medium">1</span>
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
          <div class="absolute top-4 left-0 w-1/4 h-1 bg-brand-primary rounded-full"></div>
          
          <!-- 단계들 -->
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">01</div>
            <span class="text-xs sm:text-sm font-medium text-brand-primary">약관동의</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center text-sm font-medium mb-2">02</div>
            <span class="text-xs sm:text-sm text-gray-500">회원정보입력</span>
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

      <!-- 약관 섹션 -->
      <div class="space-y-6">
        <div class="text-center mb-8">
          <h2 class="text-xl sm:text-2xl font-bold text-gray-800 mb-2">이용약관 및 개인정보 처리방침</h2>
          <p class="text-sm text-gray-600">서비스 이용을 위해 다음 약관에 동의해 주세요</p>
        </div>

        <!-- 전체 동의 -->
        <div class="agreement-all">
          <div class="flex items-start gap-4">
            <input type="checkbox" id="agreeAll" class="custom-checkbox mt-1 flex-shrink-0" />
            <div class="flex-1">
              <label for="agreeAll" class="text-lg font-bold text-brand-primary cursor-pointer block mb-2">
                모두 동의합니다.
              </label>
              <p class="text-sm text-gray-600 leading-relaxed">
                이용약관, 개인정보 수집 및 이용, 개인정보 제 3자 제공 동의에 모두 동의합니다.<br class="hidden sm:block" />
                각 사항에 대한 동의 여부를 개별적으로 선택하실 수 있으며, 선택 동의 사항에 대한 동의를 하여야 서비스를 이용하실 수 있습니다.
              </p>
            </div>
          </div>
        </div>

        <!-- 이용약관 동의 -->
        <div class="terms-card">
          <div class="terms-header">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <div class="flex-1">
                <span class="terms-label text-base">이용약관을 읽고 동의합니다.</span>
                <span class="terms-required ml-2">(필수)</span>
              </div>
              <div class="flex gap-4">
                <label class="flex items-center gap-2 cursor-pointer">
                  <input type="radio" name="terms1" value="no" class="custom-radio" />
                  <span class="text-sm text-gray-600 radio-label">동의안함</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer">
                  <input type="radio" name="terms1" value="yes" class="custom-radio" />
                  <span class="text-sm font-medium text-brand-primary radio-label">동의함</span>
                </label>
              </div>
            </div>
          </div>
          <div class="terms-content">
            <div class="text-sm text-gray-700 leading-relaxed whitespace-pre-line">
■ 이용약관
제1조(목적) 이 약관은 회사가 제공하는 서비스의 이용조건 및 절차에 관한 사항을 규정합니다.
제2조(정의) "회원"이라 함은 사이트에 개인정보를 제공하여 가입한 자를 말합니다.
제3조(약관의 효력 및 변경) 이 약관은 사이트에 게시함으로써 효력을 발생하며, 변경 시 별도 고지 후 적용됩니다.
            </div>
          </div>
        </div>

        <!-- 개인정보 수집 동의 -->
        <div class="terms-card">
          <div class="terms-header">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <div class="flex-1">
                <span class="terms-label text-base">개인정보 수집 및 이용에 대한 안내 사항을 읽고 동의합니다.</span>
                <span class="terms-required ml-2">(필수)</span>
              </div>
              <div class="flex gap-4">
                <label class="flex items-center gap-2 cursor-pointer">
                  <input type="radio" name="terms2" value="no" class="custom-radio" />
                  <span class="text-sm text-gray-600 radio-label">동의안함</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer">
                  <input type="radio" name="terms2" value="yes" class="custom-radio" />
                  <span class="text-sm font-medium text-brand-primary radio-label">동의함</span>
                </label>
              </div>
            </div>
          </div>
          <div class="terms-content">
            <div class="text-sm text-gray-700 leading-relaxed whitespace-pre-line">
■ 개인정보 수집 및 이용
수집 항목: 이름, 이메일, 휴대폰번호(필수), 생년월일, 주소 (선택)
이용 목적: 회원관리, 민원처리, 고지사항 전달 등
보유 기간: 회원 탈퇴 시까지 또는 관련 법령 기준에 따름
            </div>
          </div>
        </div>

        <!-- 개인정보 제3자 제공 동의 -->
        <div class="terms-card">
          <div class="terms-header">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <div class="flex-1">
                <span class="terms-label text-base">개인정보 제 3자 제공 동의에 대한 안내 사항을 읽고 동의합니다.</span>
                <span class="terms-required ml-2">(필수)</span>
              </div>
              <div class="flex gap-4">
                <label class="flex items-center gap-2 cursor-pointer">
                  <input type="radio" name="terms3" value="no" class="custom-radio" />
                  <span class="text-sm text-gray-600 radio-label">동의안함</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer">
                  <input type="radio" name="terms3" value="yes" class="custom-radio" />
                  <span class="text-sm font-medium text-brand-primary radio-label">동의함</span>
                </label>
              </div>
            </div>
          </div>
          <div class="terms-content">
            <div class="text-sm text-gray-700 leading-relaxed whitespace-pre-line">
■ 개인정보 제3자 제공 동의
제공받는 자: 배송업체, 결제대행사
제공 목적: 상품 배송, 결제 처리
제공 항목: 이름, 연락처, 주소, 결제정보
보유 및 이용 기간: 제공 목적 달성 후 즉시 파기
            </div>
          </div>
        </div>

        <!-- 버튼 영역 -->
        <div class="flex flex-col sm:flex-row gap-4 mt-8 pt-6 border-t border-gray-200">
          <a href="${cpath}/main" class="btn-cancel flex-1">
            취소
          </a>
          <a href="${cpath}/auth/join/userinfo" id="nextBtn" class="btn-next flex-1">
            다음
          </a>
        </div>
      </div>
    </div>
  </div>

  <script>
    $(document).ready(function () {
      // kakaoEmail 확인 및 알림
      var kakaoEmail = "${sessionScope.kakaoemail}";
      if (kakaoEmail) {
        alert(kakaoEmail + "으로 가입된 정보가 없습니다. 회원가입 페이지로 이동합니다.");
      }
      
      // naverEmail 확인 및 알림
      var naverEmail = "${sessionScope.naverInfo.email}";
      if (naverEmail) {
        alert(naverEmail + "으로 가입된 정보가 없습니다. 회원가입 페이지로 이동합니다.");
      }

      // 전체 동의 체크 시 하위 항목 모두 체크/해제
      $("#agreeAll").on("change", function () {
        const checked = $(this).is(":checked");
        $('input[name="terms1"][value="yes"]').prop("checked", checked);
        $('input[name="terms2"][value="yes"]').prop("checked", checked);
        $('input[name="terms3"][value="yes"]').prop("checked", checked);
        
        // 라디오 버튼의 경우 "동의안함"도 체크 해제
        if (checked) {
          $('input[name="terms1"][value="no"]').prop("checked", false);
          $('input[name="terms2"][value="no"]').prop("checked", false);
          $('input[name="terms3"][value="no"]').prop("checked", false);
        }
      });

      // 개별 약관 상태 변경 시 전체 동의 체크박스 상태 업데이트
      $('input[name^="terms"]').on("change", function() {
        const terms1Checked = $('input[name="terms1"][value="yes"]').is(":checked");
        const terms2Checked = $('input[name="terms2"][value="yes"]').is(":checked");
        const terms3Checked = $('input[name="terms3"][value="yes"]').is(":checked");
        
        $("#agreeAll").prop("checked", terms1Checked && terms2Checked && terms3Checked);
      });

      // 다음 버튼 클릭 시 필수 약관 동의 확인
      $("#nextBtn").on("click", function (event) {
        const terms1 = $('input[name="terms1"][value="yes"]').is(":checked");
        const terms2 = $('input[name="terms2"][value="yes"]').is(":checked");
        const terms3 = $('input[name="terms3"][value="yes"]').is(":checked");

        if (!(terms1 && terms2 && terms3)) {
          event.preventDefault();
          alert("모든 약관에 동의하셔야 다음 단계로 진행할 수 있습니다.");
        }
      });
    });
  </script>
</body>
</html>