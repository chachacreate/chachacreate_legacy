// ================================
//  전역 설정
// ================================
let cpath = "";
let storeUrl = "";
const NOTICES_PER_PAGE = 10;
let allNotices = [];
let currentPage = 1;

// ================================
//  페이지 로드 시 실행
// ================================
$(document).ready(function () {
  // 사이드바 토글
  $('.has-submenu > a').click(function () {
    $(this).next('.submenu').slideToggle(200);
  });

  // 더보기 버튼
  $('#showMoreBtn').click(function () {
    $('.extra-row').slideDown(200);
    $(this).hide();
  });

  // 상세내용 토글
  $(document).on('click', '.toggle-detail-btn', function () {
    const box = $(this).closest('td');
    const fullTextDiv = box.find('.full-text');
    fullTextDiv.slideToggle(200);
    $(this).text(fullTextDiv.is(":visible") ? "▲" : "▼");
  });

  // 상태 버튼 토글
  $(document).on('click', '.status-btn', function () {
    $(this).toggleClass('completed');
  });

  // 공지사항 목록 시작
  noticeList();
});


// ================================
//  공지사항 초기 조회
// ================================
function noticeList() {
  cpath = $("#cpath").val();
  storeUrl = $("#storeUrl").val();
  if (!cpath || !storeUrl) return;
  fetchNotices();
}


// ================================
//  공지사항 목록 불러오기 Ajax
// ================================
function fetchNotices() {
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/seller/management/noticeselect`,
    dataType: "json",
    success: result => {
      if (!result || !Array.isArray(result.data)) return;

      const notices = result.data;
      const pinned = notices.filter(n => n.noticeCheck == 1);
      const normal = notices.filter(n => n.noticeCheck != 1);
      allNotices = [...pinned, ...normal];

      if (allNotices.length === 0) {
        $("#notice-body").html(`<tr><td colspan="3">공지사항이 없습니다.</td></tr>`);
        $("#pagination").empty();
        return;
      }

      changeNoticePage(1);
      renderPagination(allNotices.length, 1);
    }
  });
}


// ================================
//  페이지에 해당하는 공지 렌더링
// ================================
function changeNoticePage(page) {
  currentPage = page;
  const start = (page - 1) * NOTICES_PER_PAGE;
  const end = start + NOTICES_PER_PAGE;
  const paginated = allNotices.slice(start, end);
  renderNotices(paginated);
}


// ================================
//  공지사항 테이블 렌더링
// ================================
function renderNotices(notices) {
  const $tbody = $("#notice-body").empty();

  notices.forEach((notice, index) => {
    const number = index + 1 + (currentPage - 1) * NOTICES_PER_PAGE;

    const row = `
      <tr class="notice-header" data-index="${index}">
        <td>${number}</td>
        <td><div class="notice-title">${notice.noticeTitle}</div></td>
        <td>
          <div class="notice-date">${notice.noticeDate}</div>
          <div class="notice-actions">
            <button class="edit-notice-btn" data-id="${notice.noticeId}">수정</button>
            <button class="delete-notice-btn" data-id="${notice.noticeId}">삭제</button>
          </div>
        </td>
      </tr>
      <tr class="notice-content" style="display: none;">
        <td colspan="3" class="notice-text">${notice.noticeText}</td>
      </tr>
    `;

    $tbody.append(row);
  });

  // 제목 클릭 시 상세내용 토글
  $(".notice-header").off("click").on("click", function (e) {
    if ($(e.target).is("button")) return;
    $(this).next(".notice-content").slideToggle();
  });
}


// ================================
//  공지사항 검색
// ================================
$(document).on("click", ".search-btn", function () {
  const keyword = $("#notice-search-input").val().trim().toLowerCase();
  if (!keyword) return changeNoticePage(1);

  const filtered = allNotices.filter(n =>
    n.noticeTitle.toLowerCase().includes(keyword)
  );

  if (filtered.length === 0) {
    $("#notice-body").html(`<tr><td colspan="3">검색 결과가 없습니다.</td></tr>`);
    $("#pagination").empty();
  } else {
    renderNotices(filtered);
    $("#pagination").empty();
  }
});


// ================================
//  페이지네이션 렌더링
// ================================
function renderPagination(totalItems, currentPage) {
  const totalPages = Math.ceil(totalItems / NOTICES_PER_PAGE);
  const $pagination = $("#pagination").empty();

  if (totalItems === 0) return;

  const pageGroup = Math.floor((currentPage - 1) / 5);
  const startPage = pageGroup * 5 + 1;
  const endPage = Math.min(startPage + 4, totalPages);

  if (currentPage > 1) $pagination.append(`<button class="page-btn" data-page="1">&laquo;</button>`);
  if (startPage > 1) $pagination.append(`<button class="page-btn" data-page="${startPage - 1}">...</button>`);
  for (let i = startPage; i <= endPage; i++) {
    const activeClass = i === currentPage ? 'active' : '';
    $pagination.append(`<button class="page-btn ${activeClass}" data-page="${i}">${i}</button>`);
  }
  if (endPage < totalPages) $pagination.append(`<button class="page-btn" data-page="${endPage + 1}">...</button>`);
  if (currentPage < totalPages) $pagination.append(`<button class="page-btn" data-page="${totalPages}">&raquo;</button>`);
}


// ================================
//  페이지 버튼 클릭
// ================================
$(document).on("click", ".page-btn", function () {
  const page = Number($(this).data("page"));
  if (isNaN(page)) return;
  changeNoticePage(page);
  renderPagination(allNotices.length, page);
});


// ================================
//  글쓰기 폼 열기/닫기
// ================================
$(document).on("click", "#write-btn", function () {
  $("#write-form").slideToggle();
});


// ================================
//  공지사항 등록
// ================================
$(document).on("click", "#submit-post", function () {
  const title = $("#new-title").val().trim();
  const content = $("#new-content").val().trim();
  const isChecked = $(".notice_checkbox").is(":checked") ? 1 : 0;

  if (!title || !content) {
    alert("제목과 내용을 입력해주세요.");
    return;
  }

  const now = new Date().toISOString().slice(0, 10);
  const postData = { storeUrl, noticeTitle: title, noticeText: content, noticeCheck: isChecked, noticeDate: now };

  $.ajax({
    type: "POST",
    url: `${cpath}/legacy/${storeUrl}/seller/management/noticeinsert`,
    contentType: "application/json",
    data: JSON.stringify(postData),
    success: function () {
      alert("공지사항 등록 완료");
      $("#new-title, #new-content").val('');
      $(".notice_checkbox").prop("checked", false);
      $("#write-form").slideUp();
      fetchNotices();
    },
    error: () => alert("등록 실패")
  });
});


// ================================
//  공지사항 삭제
// ================================
$(document).on("click", ".delete-notice-btn", function (e) {
  e.stopPropagation();
  const id = $(this).data("id");
  if (!confirm("정말 삭제하시겠습니까?")) return;

  $.ajax({
    type: "DELETE",
    url: `${cpath}/legacy/${storeUrl}/seller/management/noticedelete/${id}`,
    success: function () {
      alert("삭제되었습니다.");
      fetchNotices();
    },
    error: () => alert("삭제 실패")
  });
});


// ================================
//  공지사항 수정 폼 열기 (중복 방지)
// ================================
$(document).on("click", ".edit-notice-btn", function (e) {
  e.stopPropagation();

  $(".edit-notice-form-row").remove();

  const id = $(this).data("id");
  const notice = allNotices.find(n => n.noticeId === id);
  if (!notice) return;

  const formRow = `
    <tr class="edit-notice-form-row">
      <td colspan="3">
        <div class="edit-notice-form" id="edit-form-${id}">
          <input type="text" class="edit-title" value="${notice.noticeTitle}" />
          <textarea class="edit-content">${notice.noticeText}</textarea>
          <div class="edit-check-wrapper">
            <label class="check-label">
              <span class="check-label-text">중요 공지</span>
              <input type="checkbox" class="notice_checkbox" ${notice.noticeCheck == 1 ? "checked" : ""} />
            </label>
          </div>
          <button class="submit-edit-btn" data-id="${id}">수정 완료</button>
          <button class="cancel-edit-btn">취소</button>
        </div>
      </td>
    </tr>
  `;

  $(this).closest("tr").after(formRow);

  // 자동 스크롤 이동
  setTimeout(() => {
    const target = $(`#edit-form-${id}`);
    if (target.length) {
      $("html, body").animate({ scrollTop: target.offset().top - 100 }, 400);
    }
  }, 200);
});


// ================================
//  수정 완료 처리
// ================================
$(document).on("click", ".submit-edit-btn", function () {
  const id = $(this).data("id");
  const title = $(".edit-title").val().trim();
  const content = $(".edit-content").val().trim();
  const isChecked = $(".edit-notice-form .notice_checkbox").is(":checked") ? 1 : 0;
  const now = new Date().toISOString().slice(0, 10);

  if (!title || !content) {
    alert("제목과 내용을 입력해주세요.");
    return;
  }

  $.ajax({
    type: "PUT",
    url: `${cpath}/legacy/${storeUrl}/seller/management/noticeupdate`,
    contentType: "application/json",
    data: JSON.stringify({ noticeId: id, storeUrl, noticeTitle: title, noticeText: content, noticeCheck: isChecked, noticeDate: now }),
    success: function () {
      alert("수정 완료");
      fetchNotices();
    },
    error: () => alert("수정 실패")
  });
});


// ================================
//  수정 취소 버튼
// ================================
$(document).on("click", ".cancel-edit-btn", function () {
  $(this).closest("tr.edit-notice-form-row").remove();
});
