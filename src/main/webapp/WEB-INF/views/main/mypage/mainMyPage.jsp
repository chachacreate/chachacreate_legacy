<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri"   value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>마이페이지</title>

  <!-- jQuery & 기존 JS (필요시 유지) -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>const cpath='${cpath}';</script>
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${cpath}/resources/js/main/mypage/mainMyPage.js"></script>
  <script src="${cpath}/resources/js/main/mypage/mainMyPageSeller.js"></script>

  <!-- Tailwind CSS & Google Font (Jua) -->
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet"/>

  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: { 'jua': ['Jua','ui-sans-serif','system-ui','sans-serif'] },
          colors: {
            'brand-900':'#2D4739',
            'brand-800':'#1b2e23',
            'brand-100':'#E6F1E5',
            'brand-200':'#cde4d2',
            'brand-300':'#B0CBB0'
          },
          maxWidth: { '1440':'1440px' }
        }
      }
    }
  </script>

  <style>
    /* 부드러운 배경 */
    body { background: linear-gradient(135deg,#f8fafc 0%,#f1f5f9 100%); }
  </style>
</head>

<body class="font-jua">
  <div class="min-h-screen flex flex-col">
    <!-- 공통 헤더 -->
    <jsp:include page="/common/header.jsp" />

    <!-- storeUrl 여부에 따라 네비 분기 -->
    <c:choose>
      <c:when test="${empty storeUrl}">
        <jsp:include page="/common/main_nav.jsp" />
      </c:when>
      <c:otherwise>
        <jsp:include page="/common/storeMain_nav.jsp" />
      </c:otherwise>
    </c:choose>

    <!-- 메인 -->
    <main class="w-full max-w-[1920px] mx-auto px-4 md:px-6 xl:px-20 2xl:px-[240px] py-6 flex-1">
      <!-- 레이아웃: 모바일 1열 / 데스크톱 2열(사이드바+콘텐츠) -->
      <div class="grid grid-cols-1 lg:grid-cols-[240px_minmax(0,1fr)] gap-6">
        <!-- 왼쪽 사이드바 (반응형: 모바일=아이콘 그리드 / 데스크톱=세로 리스트) -->
        <jsp:include page="/common/main_mypage_sidenav.jsp" />

        <!-- 오른쪽 콘텐츠 -->
        <section class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
          <!-- 헤더(모바일에서 앵커 타깃) -->
          <div id="myinfo" class="scroll-mt-24 bg-gradient-to-r from-brand-900 to-gray-800 px-6 md:px-8 py-5 md:py-6">
            <h2 class="text-xl md:text-2xl text-white mb-1.5 md:mb-2">내 정보 수정</h2>
            <p class="text-gray-200 text-xs md:text-sm">개인정보를 안전하게 관리하세요</p>
          </div>

          <!-- 콘텐츠 -->
          <div class="p-6 md:p-8">
            <!-- 회원 정보 수정 폼 -->
            <form class="space-y-6">
              <!-- 기본 정보 -->
              <section class="bg-gray-50 rounded-xl p-5 md:p-6 border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                  <svg class="w-5 h-5 mr-2 text-brand-900" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"/>
                  </svg>
                  기본 정보
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">이름</label>
                    <input type="text" class="name w-full px-4 py-3 border border-gray-200 rounded-lg bg-gray-100
                           focus:outline-none focus:ring-2 focus:ring-brand-900 focus:border-transparent transition" disabled />
                  </div>

                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">이메일</label>
                    <input type="email" class="email w-full px-4 py-3 border border-gray-200 rounded-lg bg-gray-100
                           focus:outline-none focus:ring-2 focus:ring-brand-900 focus:border-transparent transition" disabled />
                  </div>

                  <div class="space-y-2 md:col-span-2 md:col-auto">
                    <label class="block text-sm font-medium text-gray-700">연락처</label>
                    <input type="text" class="phone w-full px-4 py-3 border border-gray-200 rounded-lg bg-gray-100
                           focus:outline-none focus:ring-2 focus:ring-brand-900 focus:border-transparent transition" disabled />
                  </div>
                </div>
              </section>

              <!-- 비밀번호 변경 -->
              <section class="bg-blue-50 rounded-xl p-5 md:p-6 border border-blue-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                  <svg class="w-5 h-5 mr-2 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/>
                  </svg>
                  비밀번호 변경
                </h3>

                <div class="space-y-4">
                  <div class="space-y-2">
                    <label class="block text-sm font-medium text-gray-700">현재 비밀번호</label>
                    <input type="password" class="password-current w-full px-4 py-3 border border-gray-200 rounded-lg
                           focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                           placeholder="현재 비밀번호를 입력하세요" />
                  </div>

                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="space-y-2">
                      <label class="block text-sm font-medium text-gray-700">새 비밀번호</label>
                      <input type="password" class="password w-full px-4 py-3 border border-gray-200 rounded-lg
                             focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                             placeholder="새 비밀번호" />
                    </div>

                    <div class="space-y-2">
                      <label class="block text-sm font-medium text-gray-700">새 비밀번호 확인</label>
                      <input type="password" class="password-ok w-full px-4 py-3 border border-gray-200 rounded-lg
                             focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                             placeholder="비밀번호 확인" />
                    </div>
                  </div>
                </div>
              </section>

              <!-- 주소 정보 -->
              <section class="bg-green-50 rounded-xl p-5 md:p-6 border border-green-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                  <svg class="w-5 h-5 mr-2 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>
                  </svg>
                  주소 정보
                </h3>

                <div class="space-y-4">
                  <div class="flex flex-col sm:flex-row gap-3">
                    <input type="text" class="post-num px-4 py-3 border border-gray-200 rounded-lg bg-gray-100
                           focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition
                           sm:w-[160px]" placeholder="우편번호" disabled />
                    <button type="button" class="search-btn px-6 py-3 bg-green-600 text-white rounded-lg
                            hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 transition font-medium">
                      주소 검색
                    </button>
                  </div>

                  <input type="hidden" class="address-road"   name="address-road" />
                  <input type="hidden" class="address-extra"  name="address-extra" />

                  <input type="text" class="address w-full px-4 py-3 border border-gray-200 rounded-lg
                         focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                         placeholder="주소" />

                  <input type="text" class="address-detail w-full px-4 py-3 border border-gray-200 rounded-lg
                         focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition"
                         placeholder="상세주소" />
                </div>
              </section>

              <!-- 액션 -->
              <div class="flex flex-col sm:flex-row gap-3 pt-2">
                <button type="submit" class="save-btn flex-1 sm:flex-none px-8 py-3 bg-brand-900 text-white rounded-xl
                        hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-brand-900 transition font-semibold shadow-lg">
                  변경사항 저장
                </button>
                <button type="button" class="cancel-btn flex-1 sm:flex-none px-8 py-3 bg-gray-200 text-gray-700 rounded-xl
                        hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-400 transition font-medium">
                  취소
                </button>
              </div>
            </form>

            <!-- 판매자 정보 (옵션 섹션, 필요시 노출) -->
            <section class="payment-section mt-12">
              <button type="button"
                      class="toggle-payment-form bg-gradient-to-r from-purple-600 to-purple-700 text-white px-6 py-4 rounded-xl
                             hover:from-purple-700 hover:to-purple-800 focus:outline-none focus:ring-2 focus:ring-purple-500
                             transition font-semibold shadow-lg flex items-center gap-2"
                      id="sellerInfoBtn" style="display:none;">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6 4a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>
                </svg>
                판매자 정보 관리
              </button>

              <!-- 판매자 정보 폼 -->
              <form class="payment-form mt-8 space-y-8" style="display:none;">
                <!-- 계좌 등록 -->
                <section class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
                  <div class="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-4">
                    <div class="flex items-center text-white">
                      <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6 4a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>
                      </svg>
                      <span class="font-semibold">계좌 등록하기</span>
                    </div>
                    <p class="text-blue-100 text-sm mt-1">판매수익금으로 입금 받을 계좌를 등록해주세요</p>
                  </div>

                  <div class="p-6 space-y-6">
                    <div class="space-y-2">
                      <label for="account-owner" class="block text-sm font-medium text-gray-700">예금주명</label>
                      <input type="text" id="account-owner"
                             class="input-box w-full px-4 py-3 border border-gray-200 rounded-lg bg-gray-100
                                    focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                             readonly value="${sessionScope.loginMember.memberName}" />
                    </div>

                    <div id="bank-section" class="space-y-2">
                      <label for="bank" class="block text-sm font-medium text-gray-700">은행 선택</label>
                      <select id="bankselect"
                              class="input-box w-full px-4 py-3 border border-gray-200 rounded-lg
                                     focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition bg-white">
                        <option value="">은행을 선택해주세요</option>
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
                    </div>

                    <div id="account-notice" class="space-y-2">
                      <label for="account-number" class="block text-sm font-medium text-gray-700">계좌번호</label>
                    </div>

                    <div class="bg-amber-50 border border-amber-200 rounded-xl p-4">
                      <div class="flex items-start gap-3">
                        <svg class="w-5 h-5 text-amber-600 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                          <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                        </svg>
                        <div>
                          <div class="font-semibold text-amber-800 mb-2">간편결제로 연결할 수 없는 계좌</div>
                          <ul class="text-sm text-amber-700 space-y-1">
                            <li>• 본인 명의가 아닌 계좌</li>
                            <li>• 가상계좌/적금/펀드/정기예금 등의 계좌</li>
                            <li>• 휴대폰 번호 등으로 만든 평생 계좌번호</li>
                            <li>• 계좌에 문제가 있는 경우 (예: 지급정지 또는 해약된 경우)</li>
                          </ul>
                        </div>
                      </div>
                    </div>

                    <div class="account-input grid grid-cols-1 md:grid-cols-3 gap-4">
                      <input type="text" id="accountnum" class="input-box2 px-4 py-3 border border-gray-200 rounded-lg
                              focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                             placeholder="계좌번호 (-없이 입력)" disabled />
                      <input type="text" id="accountname" class="input-box2 px-4 py-3 border border-gray-200 rounded-lg bg-gray-100
                              focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                             placeholder="예금주명" readonly />
                      <div class="flex gap-2">
                        <button type="button" class="account-button px-4 py-3 bg-blue-600 text-white rounded-lg
                                hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 transition font-medium flex-1"
                                id="accountSubmit" style="display:none;">계좌 인증</button>
                        <button type="button" class="account-button px-4 py-3 bg-gray-600 text-white rounded-lg
                                hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500 transition font-medium flex-1"
                                id="accountEditBtn" style="display:none;">수정하기</button>
                      </div>
                    </div>
                  </div>
                </section>

                <!-- 나의 이력 등록 -->
                <section class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
                  <div class="bg-gradient-to-r from-green-500 to-green-600 px-6 py-4">
                    <div class="flex items-center text-white">
                      <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd"/>
                      </svg>
                      <span class="font-semibold">나의 이력 등록하기</span>
                    </div>
                    <p class="text-green-100 text-sm mt-1">판매자님의 작품 사진과 이력을 등록해주세요</p>
                  </div>

                  <div class="p-6">
                    <div class="space-y-4">
                      <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-700">이력 설명</label>
                        <textarea class="career-text w-full px-4 py-3 border border-gray-200 rounded-lg
                                   focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent transition resize-none"
                                  rows="4" placeholder="판매자님의 경력과 전문분야를 소개해주세요 (최대 150자)"></textarea>
                        <div class="char-count text-sm text-gray-500 text-right">0/150</div>
                      </div>
                    </div>
                  </div>
                </section>

                <!-- 판매자용 하단 버튼 -->
                <div class="form-actions flex flex-col sm:flex-row gap-3 pt-2" id="sellerFormActions" style="display:none;">
                  <button type="submit" class="save-btn flex-1 sm:flex-none px-8 py-3 bg-purple-600 text-white rounded-xl
                          hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 transition font-semibold shadow-lg"
                          id="saveAllBtn">모든 정보 저장</button>
                  <button type="button" class="cancel-btn flex-1 sm:flex-none px-8 py-3 bg-gray-200 text-gray-700 rounded-xl
                          hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-400 transition font-medium cancel-payment">
                    취소
                  </button>
                </div>
              </form>
            </section>
          </div>
        </section>
      </div>
    </main>

    <!-- 푸터 -->
    <footer class="bg-white border-t border-gray-200 py-8 mt-16">
      <div class="max-w-1200 mx-auto px-6 text-center">
        <p class="text-gray-600">&copy; 2025 HandCraft Mall. All Rights Reserved.</p>
      </div>
    </footer>
  </div>

  <!-- 페이지 스크립트 -->
  <script>
    // 1) 글자수 카운트
    $(document).on('input', '.career-text', function () {
      const max = 150;
      const len = $(this).val().length;
      $(this).siblings('.char-count').text(Math.min(len,max) + '/' + max);
      if (len > max) $(this).val($(this).val().substring(0, max));
    });

    // 2) 파일 업로드(선택적) – 미리보기 샘플 훅 (upload-placeholder / fileInput 존재 가정 시)
    $(function () {
      $('.upload-placeholder').on('click', function () { $('#fileInput').click(); });
      $('#fileInput').on('change', function (e) {
        const f = e.target.files[0];
        if (!f) return;
        const ok = ['jpg','jpeg','png','gif'];
        const ext = f.name.toLowerCase().split('.').pop();
        if (!ok.includes(ext)) { alert('jpg, jpeg, png, gif만 가능합니다.'); $(this).val(''); return; }
        const reader = new FileReader();
        reader.onload = function () {
          $('.upload-placeholder').html('<img src="'+reader.result+'" style="max-width:100%;max-height:100%;object-fit:contain;">');
        };
        reader.readAsDataURL(f);
      });
    });

    // 3) 다음 우편번호 검색
    function openDaumPostcode() {
      new daum.Postcode({
        oncomplete: function(data) {
          const zonecode = data.zonecode || '';
          const roadAddr = data.roadAddress || data.address || '';
          const extra    = [data.bname, data.buildingName].filter(Boolean).join(' ');
          $('.post-num').val(zonecode);
          $('.address-road').val(roadAddr);
          $('.address-extra').val(extra);
          $('.address').val(roadAddr + (extra ? ' ('+extra+')' : ''));
          $('.address-detail').focus();
        }
      }).open();
    }
    $(document).on('click', '.search-btn', openDaumPostcode);

    // 4) 같은 페이지 내 앵커(#myinfo) 스무스 스크롤
    document.querySelectorAll('a[href^="#"]').forEach(a=>{
      a.addEventListener('click', (e)=>{
        const t = document.querySelector(a.getAttribute('href'));
        if(t){ e.preventDefault(); t.scrollIntoView({behavior:'smooth', block:'start'}); }
      });
    });
    window.addEventListener('load', ()=>{
      if(location.hash){
        const t = document.querySelector(location.hash);
        if(t) setTimeout(()=> t.scrollIntoView({behavior:'smooth', block:'start'}), 50);
      }
    });
  </script>
</body>
</html>
