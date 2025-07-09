<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>스토어 목록</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mainStoreList.css">
</head>
<body>
<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/main_nav.jsp" />

<!-- ✅ 전체 페이지 컨테이너 -->
<div class="store-page-container">

  <!-- ✅ 서브탭 -->
  <jsp:include page="/common/main_stores_subnav.jsp" />

  <!-- ✅ 검색창: 서브탭 바로 밑에 위치 -->
  <div id="product-search">
    <form id="search-form" action="/api/main/productlist" method="get">
      <input type="text" name="query" placeholder="Search" id="search-input" />
      <button type="submit" id="search-button">🔍</button>
    </form>
  </div>


    <!-- 스토어 제목 -->
    <h1 class="store-title">뜨락상회 입점 스토어</h1>
<!-- 정렬/필터 버튼 -->
    <div class="filter-buttons">
      <button class="filter-button active">최신순</button>
      <button class="filter-button">인기 상품순</button>
      <button class="filter-button">가나다순</button>
      <button class="filter-button">즐겨찾기</button>
      <button class="filter-button" id="toggle-category">카테고리별 ▼</button>
    </div>

<!-- 카테고리 -->
<div id="category-section" class="category-hidden">
<div id="category-section">
  <div class="filter-group">
    <div class="filter-group-title">카테고리</div>
    <div class="filter-options">
      <button class="filter-btn selected">면세점</button>
      <button class="filter-btn">육아</button>
      <button class="filter-btn">스포츠</button>
    </div>
  </div>

  <div class="filter-group">
    <div class="filter-group-title">브랜드</div>
    <div class="filter-options">
      <button class="filter-btn">나이키</button>
      <button class="filter-btn selected">스투시</button>
      <button class="filter-btn">커버낫</button>
    </div>
  </div>

  <div class="filter-group">
    <div class="filter-group-title">가격</div>
    <div class="filter-options">
      <button class="filter-btn selected">2천원~1만원</button>
      <button class="filter-btn">1만원~2만원</button>
    </div>
  </div>

  <div class="selected-filters">
    <button class="reset-btn">↻</button>
    <div class="selected-tag">면세점 <button class="remove-tag">✕</button></div>
    <div class="selected-tag">스투시 <button class="remove-tag">✕</button></div>
    <div class="selected-tag">2천원~1만원 <button class="remove-tag">✕</button></div>
  </div>
</div>
</div>


    
    
<!--  스토어 목록 -->
<div class="store-grid-container">


</div>

<!-- 페이지네이션 영역 -->
<div id="pagination" class="pagination">
	  <!-- 페이지 번호가 동적으로 들어갈 자리 -->
	  <!-- 한페이지에 상품 가로3개 세로 4개 총 12개, 
	  그 이상이면 페이지 이동하는 버튼 동적으로 생성 
	  < button >&lt;</ button >  : 첫 페이지 이동
       - < button >1</ button > : 최대 5개까지
       - < button >&gt;</ button >  : 다음 페이지 그룹 또는 마지막 페이지 이동-->
</div>
	  
	  <!-- 테스트 용도 -->
	  <div id="pagination" class="pagination">
		  <button class="active">1</button>
		  <button>2</button>
		  <button>3</button>
		  <button>4</button>
		  <button>5</button>
		</div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  const filterButtons = document.querySelectorAll('.filter-btn');
  const selectedFiltersContainer = document.querySelector('.selected-filters');

  // ✅ 필터 버튼 클릭 시 선택 영역 반영
  filterButtons.forEach(btn => {
	  btn.addEventListener('click', () => {
		  const value = btn.textContent.trim();
		  const alreadySelected = btn.classList.contains('selected');

		  btn.classList.toggle('selected');

		  if (!alreadySelected) {
		    // 선택된 태그 추가
		    const tag = document.createElement('div');
		    tag.className = 'selected-tag';
		    tag.setAttribute('data-value', value);
		    tag.innerHTML = `${value} <button class="remove-tag">✕</button>`;
		    selectedFiltersContainer.appendChild(tag);
		    attachRemoveEvent(tag.querySelector('.remove-tag'));
		  } else {
		    // ❗ 이미 선택된 걸 다시 클릭하면 아래 태그도 삭제
		    const tagToRemove = selectedFiltersContainer.querySelector(`.selected-tag[data-value="${value}"]`);
		    if (tagToRemove) tagToRemove.remove();
		  }
		});
  });

  // ✅ 제거 이벤트 함수 정의
  function attachRemoveEvent(button) {
    button.addEventListener('click', (e) => {
      const tag = e.target.closest('.selected-tag');
      const value = tag.getAttribute('data-value');
      tag.remove();

      // 버튼에서도 selected 해제
      filterButtons.forEach(btn => {
        if (btn.textContent.trim() === value) {
          btn.classList.remove('selected');
        }
      });
    });
  }

  // ✅ 초기화 버튼 기능 (↻)
  const resetBtn = document.querySelector('.reset-btn');
  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      // 선택된 태그 전부 제거
      selectedFiltersContainer.querySelectorAll('.selected-tag').forEach(tag => tag.remove());

      // 버튼의 selected 해제
      filterButtons.forEach(btn => btn.classList.remove('selected'));
    });
  }
});

/* 카테고리 버튼 클릭시 필터 나타냄 */
const toggleCategoryBtn = document.getElementById('toggle-category');
const categorySection = document.getElementById('category-section');

toggleCategoryBtn.addEventListener('click', () => {
  categorySection.classList.toggle('category-hidden');
});


// --------------스토어 목록--------------------
$(document).ready(function () {
	  $.ajax({
	    url: '${cpath}/api/main/store/stores',
	    method: 'GET',
        contentType: 'application/json',
	    success: function (response) {
	      if (response.status === 200) {
	        const storeList = response.data;
	        const container = $('.store-grid-container');
	        container.empty(); // 기존 카드 제거

	        storeList.forEach(store => {
	          const card = `
	        	  <div class="store-card" data-url="\${store.storeUrl}">
	              <div class="store-image">
	                <img class="product-img" src="${cpath}/resources/productImages/\${store.logoImg}" alt="${store.storeName}" />
	              </div>
	              <div class="store-content">
	                <h2 class="store-name">\${store.storeName}</h2>
	                <div class="store-categories">
	                  <span class="category">판매수: \${store.saleCnt}</span>
	                  <span class="category">조회수: \${store.viewCnt}</span>
	                </div>
	                <div class="store-description">
	                  ${store.storeDetail}
	                </div>
	              </div>
	            </div>
	          `;
	          container.append(card);
	        });
		    $('.store-card').on('click', function () {
		        const storeUrl = $(this).data('url');
		        window.location.href = `${cpath}/\${storeUrl}`;
		      });
	      } else {
	        $('.store-grid-container').html('<p>스토어가 없습니다.</p>');
	      }
	    },
	    error: function (xhr, status, error) {
	      console.error('스토어 목록 불러오기 실패:', error);
	      $('.store-grid-container').html('<p>스토어 목록을 불러오는 중 오류가 발생했습니다.</p>');
	    }
	  });
	});
</script>


</body>
</html>