// 현재 선택된 페이지 번호 저장 (기본값 1)
let currentPage = 1;

// 페이지네이션을 렌더링하는 함수
// totalItems: 전체 상품 수
// currentPage: 현재 페이지 번호
function renderPagination(totalItems, currentPage) {
  const totalPages = Math.ceil(totalItems / PRODUCTS_PER_PAGE); 	// 총 페이지 수 계산
  const $pagination = $('#pagination'); 												// 페이지네이션 영역 선택
  $pagination.empty(); 																		// 이전에 생성된 버튼 초기화

  // 상품이 1개도 없으면 페이지네이션 표시 안 함
  if (totalItems === 0) return;

  // 한 번에 보여줄 페이지 그룹 수 설정 (예: 1~5, 6~10)
  const pageGroup = Math.floor((currentPage - 1) / 5);
  const startPage = pageGroup * 5 + 1; // 현재 그룹의 시작 페이지
  const endPage = Math.min(startPage + 4, totalPages); // 현재 그룹의 마지막 페이지 (총 페이지 초과 금지)

  // ◀ 처음 페이지로 이동 버튼 (<<)
  if (currentPage > 1) {
    $pagination.append(`<button class="page-btn first" data-page="1">&laquo;</button>`);
  }

  // ... 이전 그룹으로 이동 버튼
  if (startPage > 1) {
    $pagination.append(`<button class="page-btn prev" data-page="${startPage - 1}">...</button>`);
  }

  // 페이지 번호 버튼들 생성 (ex. 1 2 3 4 5)
  for (let i = startPage; i <= endPage; i++) {
    const activeClass = i === currentPage ? 'active' : ''; // 현재 페이지는 강조
    $pagination.append(`<button class="page-btn page-number ${activeClass}" data-page="${i}">${i}</button>`);
  }

  // ... 다음 그룹으로 이동 버튼
  if (endPage < totalPages) {
    $pagination.append(`<button class="page-btn next" data-page="${endPage + 1}">...</button>`);
  }

  // ▶ 마지막 페이지로 이동 버튼 (>>)
  if (currentPage < totalPages) {
    $pagination.append(`<button class="page-btn last" data-page="${totalPages}">&raquo;</button>`);
  }
}

// 페이지 버튼 클릭 시 동작하는 이벤트 핸들러
$(document).on("click", ".page-btn", function () {
  const page = Number($(this).data("page")); // 클릭한 버튼의 page 번호 가져오기
  const maxPage = Math.ceil(allProducts.length / PRODUCTS_PER_PAGE); // 실제 존재하는 마지막 페이지

  // 클릭한 페이지가 실제 존재하는 페이지보다 크면 알림 출력
  if (page > maxPage) {
    alert("상품 준비 중입니다.");
    return;
  }

  // 정상적인 숫자일 경우 페이지 변경
  if (!isNaN(page)) {
    changePage(page); // storeAllProduct.js에 있는 페이지 전환 함수 호출
  }
});
