// ================================
//  전역 설정
// ================================
//let cpath = "";
//let storeUrl = "";
const NOTICES_PER_PAGE = 10;      // 공지사항은 한 페이지에 10개씩 표시
let allNotices = [];              // 전체 공지사항 데이터를 저장하는 배열
let currentPage = 1;              // 현재 페이지 번호

// ================================
// 페이지 로드 시 실행
// ================================
$(document).ready(() => {
  // <input type="hidden">에서 경로 값 추출
  //cpath = document.getElementById("cpath").value || "";
  //storeUrl = document.getElementById("storeUrl").value || "";
  // 필수 값 유효성 검사
  //if (!cpath || !storeUrl) return;

  if (!contextPath || !storeUrl) {
    console.error("contextPath 또는 storeUrl 값이 없습니다.");
    return;
  }

  // 공지사항 데이터 Ajax로 조회 시작
  fetchNotices();
});

// ================================
// 공지사항 목록 Ajax로 불러오기
// ================================
function fetchNotices() {
  $.ajax({
    url: `${contextPath}/${storeUrl}/seller/management/noticeselect`,
    dataType: "json",
    success: result => {
      if (!result || !Array.isArray(result.data)) return;

      const notices = result.data;

      // 중요 공지 먼저 정렬 (noticeCheck == 1)
      const pinned = notices.filter(n => n.noticeCheck == 1);
      const normal = notices.filter(n => n.noticeCheck != 1);
      allNotices = [...pinned, ...normal];

      // 공지사항이 없는 경우 메시지 표시
      if (allNotices.length === 0) {
        $("#notice-body").html(`<tr><td colspan="3">공지사항이 없습니다.</td></tr>`);
        $("#pagination").empty();
        return;
      }

      // 첫 페이지 렌더링
      changeNoticePage(1);
      renderPagination(allNotices.length, 1);
    },
    error: () => {
      // Ajax 실패 시 처리 (silent fail)
    }
  });
}

// ================================
// 현재 페이지에 해당하는 공지사항만 보여주기
// ================================
function changeNoticePage(page) {
  currentPage = page;
  const start = (page - 1) * NOTICES_PER_PAGE;
  const end = start + NOTICES_PER_PAGE;
  const paginated = allNotices.slice(start, end);

  renderNotices(paginated);
}

// ================================
// 공지사항 테이블에 출력 렌더링
// ================================
function renderNotices(notices) {
  const $tbody = $("#notice-body");
  $tbody.empty();

  notices.forEach((notice, index) => {
    const number = index + 1 + (currentPage - 1) * NOTICES_PER_PAGE;

    const noticeRow = `
      <tr class="notice-header" data-index="${index}">
        <td>${number}</td>
        <td><div class="notice-title">${notice.noticeTitle}</div></td>
        <td><div class="notice-date">${notice.noticeDate}</div></td>
      </tr>
      <tr class="notice-content" style="display: none;">
        <td colspan="3" class="notice-text">${notice.noticeText}</td>
      </tr>
    `;
    $tbody.append(noticeRow);
  });

  // 공지 제목 클릭 시 상세 내용 토글
  $(".notice-header").off("click").on("click", function () {
    $(this).next(".notice-content").slideToggle();
  });
}

// ================================
// 검색 버튼 클릭 이벤트
// ================================
$(document).on("click", ".search-btn", function () {
  const keyword = $("#notice-search-input").val().trim().toLowerCase();

  if (!keyword) {
    changeNoticePage(1);
    renderPagination(allNotices.length, 1);
    return;
  }

  const filtered = allNotices.filter(n => n.noticeTitle.toLowerCase().includes(keyword));

  if (filtered.length === 0) {
    $("#notice-body").html(`<tr><td colspan="3">검색 결과가 없습니다.</td></tr>`);
    $("#pagination").empty();
  } else {
    renderNotices(filtered);
    $("#pagination").empty();  // 검색 결과는 페이징 없이 보여줌
  }
});


// ================================
// 페이지네이션 버튼 동적 생성
// ================================
function renderPagination(totalItems, currentPage) {
  const totalPages = Math.ceil(totalItems / NOTICES_PER_PAGE);
  const $pagination = $("#pagination").empty();

  if (totalItems === 0) return;

  const pageGroup = Math.floor((currentPage - 1) / 5);
  const startPage = pageGroup * 5 + 1;
  const endPage = Math.min(startPage + 4, totalPages);

  // ◀ 첫 페이지로 이동
  if (currentPage > 1) {
    $pagination.append(`<button class="page-btn first" data-page="1">&laquo;</button>`);
  }

  // ... 이전 페이지 그룹
  if (startPage > 1) {
    $pagination.append(`<button class="page-btn prev" data-page="${startPage - 1}">...</button>`);
  }

  // 페이지 번호 버튼
  for (let i = startPage; i <= endPage; i++) {
    const activeClass = i === currentPage ? 'active' : '';
    $pagination.append(`<button class="page-btn page-number ${activeClass}" data-page="${i}">${i}</button>`);
  }

  // ... 다음 페이지 그룹
  if (endPage < totalPages) {
    $pagination.append(`<button class="page-btn next" data-page="${endPage + 1}">...</button>`);
  }

  // ▶ 마지막 페이지로 이동
  if (currentPage < totalPages) {
    $pagination.append(`<button class="page-btn last" data-page="${totalPages}">&raquo;</button>`);
  }
}

// ================================
// 페이지네이션 버튼 클릭 이벤트 처리
// ================================
$(document).on("click", ".page-btn", function () {
  const page = Number($(this).data("page"));
  const maxPage = Math.ceil(allNotices.length / NOTICES_PER_PAGE);

  if (isNaN(page) || page > maxPage) return;

  changeNoticePage(page);
  renderPagination(allNotices.length, page);
});
