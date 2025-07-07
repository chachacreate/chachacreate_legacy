// ================================
// 전역 설정
// ================================
let cpath = "";
let storeUrl = "";
const NOTICES_PER_PAGE = 10;
let allNotices = [];
let currentPage = 1;

// ================================
// 공지사항 버튼 클릭 시 실행
// ================================
$(document).on("click", "#notice", function () {
  cpath = document.getElementById("cpath")?.value || "";
  storeUrl = document.getElementById("storeUrl")?.value || "";
  if (!cpath || !storeUrl) return;

  $(".suggestion-box").empty();

  const noticeHTML = `
    <div class="wrapper">
      <main class="notice-container">
        <h2>공지사항</h2>

        <div class="search-box">
          <input type="text" id="notice-search-input" placeholder="조회할 제목을 입력하세요">
          <button class="search-btn">검색</button>
        </div>

        <div class="write-area">
          <button id="write-btn">+</button>
          <div id="write-form" style="display: none;">
            <input type="text" id="new-title" placeholder="제목 입력">
            <textarea id="new-content" placeholder="내용 입력"></textarea>
            <label class="check-label">
            <input type="checkbox" class="notice_checkbox">중요 공지사항 여부
            </label>
            <button id="submit-post">건의사항 등록</button> 
          </div>
        </div>

        <div class="notice-table">
          <table>
            <thead>
              <tr><th>번호</th><th>제목</th><th>작성일</th></tr>
            </thead>
            <tbody id="notice-body">
              <!-- 공지사항 행 삽입 위치 -->
            </tbody>
          </table>
        </div>

        <div id="pagination" class="pagination"></div>
      </main>
    </div>
  `;

  $(".suggestion-box").append(noticeHTML);

  fetchNotices();
});

// ================================
// 공지사항 Ajax 조회
// ================================
function fetchNotices() {
  $.ajax({
    url: `${cpath}/api/${storeUrl}/seller/management/noticeselect`,
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
// 페이지 변경 시 공지사항 렌더링
// ================================
function changeNoticePage(page) {
  currentPage = page;
  const start = (page - 1) * NOTICES_PER_PAGE;
  const end = start + NOTICES_PER_PAGE;
  const paginated = allNotices.slice(start, end);
  renderNotices(paginated);
}

// ================================
// 공지사항 테이블 렌더링
// ================================
function renderNotices(notices) {
  const $tbody = $("#notice-body");
  $tbody.empty();

  notices.forEach((notice, index) => {
    const number = index + 1 + (currentPage - 1) * NOTICES_PER_PAGE;

    const noticeRow = `
      <tr class="notice-header" data-index="${index}">
        <td>${number}</td>
        <td>
          <div class="notice-title">${notice.noticeTitle}</div>
        </td>
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
    $tbody.append(noticeRow);
  });

  // 제목 클릭 시 내용 토글
  $(".notice-header").off("click").on("click", function (e) {
    if ($(e.target).is("button")) return; // 버튼 클릭 시 토글 방지
    $(this).next(".notice-content").slideToggle();
  });
}


// ================================
// 검색 기능
// ================================
$(document).on("click", ".search-btn", function () {
  const keyword = $("#notice-search-input").val().trim().toLowerCase();
  if (!keyword) {
    changeNoticePage(1);
    renderPagination(allNotices.length, 1);
    return;
  }

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
// 페이지네이션 렌더링
// ================================
function renderPagination(totalItems, currentPage) {
  const totalPages = Math.ceil(totalItems / NOTICES_PER_PAGE);
  const $pagination = $("#pagination").empty();

  if (totalItems === 0) return;

  const pageGroup = Math.floor((currentPage - 1) / 5);
  const startPage = pageGroup * 5 + 1;
  const endPage = Math.min(startPage + 4, totalPages);

  if (currentPage > 1) {
    $pagination.append(`<button class="page-btn first" data-page="1">&laquo;</button>`);
  }
  if (startPage > 1) {
    $pagination.append(`<button class="page-btn prev" data-page="${startPage - 1}">...</button>`);
  }
  for (let i = startPage; i <= endPage; i++) {
    const activeClass = i === currentPage ? 'active' : '';
    $pagination.append(`<button class="page-btn page-number ${activeClass}" data-page="${i}">${i}</button>`);
  }
  if (endPage < totalPages) {
    $pagination.append(`<button class="page-btn next" data-page="${endPage + 1}">...</button>`);
  }
  if (currentPage < totalPages) {
    $pagination.append(`<button class="page-btn last" data-page="${totalPages}">&raquo;</button>`);
  }
}

// ================================
// 페이지네이션 클릭 이벤트
// ================================
$(document).on("click", ".page-btn", function () {
  const page = Number($(this).data("page"));
  const maxPage = Math.ceil(allNotices.length / NOTICES_PER_PAGE);
  if (isNaN(page) || page > maxPage) return;

  changeNoticePage(page);
  renderPagination(allNotices.length, page);
});

// ================================
// 글쓰기 영역 토글 버튼
// ================================
$(document).on("click", "#write-btn", function () {
  $("#write-form").slideToggle();
});

// ================================
// 공지사항 등록 버튼 클릭 이벤트
// ================================
$(document).on("click", "#submit-post", function () {

  const title = $("#new-title").val().trim();
  const content = $("#new-content").val().trim();
  const isChecked = $(".notice_checkbox").is(":checked") ? 1 : 0;

  if (!title || !content) {
    alert("제목과 내용을 모두 입력해주세요.");
    return;
  }
  
  const now = new Date();
  const noticeDate = now.toISOString().slice(0,10);

  const postData = {
    storeUrl: storeUrl,
    noticeTitle: title,
    noticeText: content,
    noticeCheck: isChecked,
    noticeDate: noticeDate
  };

  $.ajax({
    type: "POST",
    url: `${cpath}/api/${storeUrl}/seller/management/noticeinsert`,
    contentType: "application/json",
    data: JSON.stringify(postData),
    success: function (response) {
      alert("공지사항이 등록되었습니다.");
      $("#new-title").val('');
      $("#new-content").val('');
      $(".notice_checkbox").prop("checked", false);
      $("#write-form").slideUp();

      // 등록 후 목록 새로고침
      fetchNotices();
    },
    error: function (xhr) {
      alert("공지사항 등록에 실패했습니다.");
    }
  });

});

// ================================
// 공지사항 삭제 버튼 클릭 이벤트
// ================================
$(document).on("click", ".delete-notice-btn", function (e) {
  e.stopPropagation();  // 삭제 버튼 클릭 시 내용 토글 방지

  const noticeId = $(this).data("id");
  if (!confirm("정말 삭제하시겠습니까?")) return;

  $.ajax({
    type: "DELETE",
    url: `${cpath}/api/${storeUrl}/seller/management/noticedelete/${noticeId}`,
    success: function (response) {
      alert("공지사항이 삭제되었습니다.");
      fetchNotices(); // 목록 다시 불러오기
    },
    error: function (xhr) {
      if (xhr.status === 401) {
        alert("로그인이 필요합니다.");
      } else if (xhr.status === 404) {
        alert("삭제할 공지사항이 존재하지 않습니다.");
      } else {
        alert("공지사항 삭제에 실패했습니다.");
      }
    }
  });
});

// ================================
// 공지사항 수정 버튼 클릭 시 폼 보여주기
// ================================
$(document).on("click", ".edit-notice-btn", function (e) {
  e.stopPropagation(); // 제목 토글 방지

  const $row = $(this).closest("tr");
  const index = $row.data("index");
  const notice = allNotices[index];  // 현재 공지사항 정보

  // 기존 표시된 폼 제거
  $(".edit-notice-form-row").remove();

  const editFormRow = `
    <tr class="edit-notice-form-row">
      <td colspan="3">
        <div class="edit-notice-form">
          <input type="text" id="edit-title" value="${notice.noticeTitle}" placeholder="제목 입력" />
          <textarea id="edit-content" placeholder="내용 입력">${notice.noticeText}</textarea>
          <label class="check-label">
            <input type="checkbox" id="edit-check" ${notice.noticeCheck === 1 ? "checked" : ""}/> 중요 공지
          </label>
          <button class="submit-edit-btn" data-id="${notice.noticeId}">수정 완료</button>
          <button class="cancel-edit-btn">취소</button>
        </div>
      </td>
    </tr>
  `;

  $row.after(editFormRow);
});


// ================================
// 수정 완료 버튼 클릭 시 요청
// ================================
$(document).on("click", ".submit-edit-btn", function () {
  const noticeId = $(this).data("id");
  const title = $("#edit-title").val().trim();
  const content = $("#edit-content").val().trim();
  const isChecked = $("#edit-check").is(":checked") ? 1 : 0;

  if (!title || !content) {
    alert("제목과 내용을 모두 입력해주세요.");
    return;
  }

  // 현재 날짜 (YYYY-MM-DD)
  const now = new Date();
  const noticeDate = now.toISOString().slice(0, 10);

  const updateData = {
    noticeId: noticeId,
    storeUrl: storeUrl,
    noticeTitle: title,
    noticeText: content,
    noticeCheck: isChecked,
    noticeDate: noticeDate
  };

  $.ajax({
    type: "PUT",
    url: `${cpath}/api/${storeUrl}/seller/management/noticeupdate`,
    contentType: "application/json",
    data: JSON.stringify(updateData),
    success: function () {
      alert("공지사항이 수정되었습니다.");
      fetchNotices(); // 수정 후 목록 갱신
    },
    error: function () {
      alert("공지사항 수정에 실패했습니다.");
    }
  });
});

// ================================
// 수정 취소 버튼 클릭 시 폼 제거
// ================================
$(document).on("click", ".cancel-edit-btn", function () {
  $(this).closest("tr.edit-notice-form-row").remove();
});



