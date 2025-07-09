document.addEventListener("DOMContentLoaded", () => {
  const pathSegments = window.location.pathname.split("/");
  const storeUrl = pathSegments[2];
  const productId = pathSegments[4];
  const cpath = document.body.getAttribute("data-cpath") || "";

  let orderDetailId = null;
  const loggedInMemberId = window.loggedInMemberId || null;

  // 1. 로그인 여부 관계없이 리뷰 목록 먼저 로딩
  loadReviews();

  // 2. 로그인 안 된 경우: 리뷰 작성 폼 숨기고 종료
  if (!loggedInMemberId) {
    document.querySelector(".review-form").style.display = "none";
    return;
  }

  // 3. 로그인된 경우: 주문상세ID 조회 후 작성 가능 여부 확인
  const finalUrl = `${cpath}/api/${storeUrl}/order/${loggedInMemberId}/products/${productId}/orderdetail`;

  $.ajax({
    url: finalUrl,
    method: "GET",
    dataType: "json",
    success: function (res) {
      if (res.status === 200 && res.data != null) {
        orderDetailId = res.data;
        checkReviewWritable(orderDetailId);
        bindSubmit();
      } else {
        document.querySelector(".review-form").style.display = "none";
        console.warn("리뷰 작성 가능한 주문상세ID가 없습니다.");
      }
    },
    error: function () {
      document.querySelector(".review-form").style.display = "none";
      console.error("주문상세ID 조회 실패");
    }
  });

  function checkReviewWritable(orderDetailId) {
    $.ajax({
      url: `${cpath}/api/${storeUrl}/productdetail/${productId}/review/check`,
      method: "GET",
      data: { orderDetailId },
      dataType: "json",
      success: function (res) {
        if (res.status === 200 && res.data === true) {
          document.querySelector(".review-form").style.display = "block";
        } else {
          document.querySelector(".review-form").style.display = "none";
        }
      },
      error: function () {
        console.error("리뷰 작성 가능 여부 확인 실패");
        document.querySelector(".review-form").style.display = "none";
      }
    });
  }

  function loadReviews() {
    $.ajax({
      url: `${cpath}/api/${storeUrl}/productdetail/${productId}/review`,
      method: "GET",
      dataType: "json",
      success: function (data) {
        const reviewList = document.querySelector(".review-list");
        const noReviewMessage = document.querySelector(".no-review-message");
        reviewList.innerHTML = "";

        if (!data.data || data.data.length === 0) {
          noReviewMessage.style.display = "block";
          return;
        } else {
          noReviewMessage.style.display = "none";
        }

        data.data.forEach(review => {
          const isMyReview = loggedInMemberId && review.memberId === loggedInMemberId;

          const reviewItem = document.createElement("div");
          reviewItem.className = "review-item";
          reviewItem.dataset.reviewId = review.reviewId;

          reviewItem.innerHTML = `
            <div class="review-header">
              <div class="review-meta">
                <span class="review-writer">${review.memberName || "익명"}</span>
                <span class="review-date">${new Date(review.reviewDate).toLocaleDateString()}</span>
              </div>
              <div class="review-buttons">
                ${
                  isMyReview
                    ? `<button class="review-edit-btn">수정</button>
                       <button class="review-delete-btn">삭제</button>`
                    : `<button class="review-report-btn">신고</button>`
                }
              </div>
            </div>
            <div class="review-content">${review.reviewText}</div>
          `;

          reviewList.appendChild(reviewItem);

          if (isMyReview) {
            bindReviewEvents(reviewItem);
          } else {
            const reportBtn = reviewItem.querySelector(".review-report-btn");
            if (reportBtn) {
              reportBtn.addEventListener("click", () => {
                alert("신고 기능은 준비 중입니다.");
              });
            }
          }
        });
      },
      error: function (xhr) {
        console.error(xhr);
        alert("리뷰 목록을 불러오지 못했습니다.");
      }
    });
  }

  function bindSubmit() {
    document.getElementById("review-submit-btn").addEventListener("click", () => {
      const content = document.getElementById("review-input").value.trim();
      if (!content) {
        alert("리뷰 내용을 입력하세요.");
        return;
      }
      addReview(content);
      document.getElementById("review-input").value = "";
    });
  }

// 리뷰 등록
  function addReview(reviewText) {
    $.ajax({
      url: `${cpath}/api/${storeUrl}/productdetail/${productId}/review`,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        reviewText,
        orderDetailId
      }),
      xhrFields: { withCredentials: true },
      success: function (res) {
        if (res.status === 201 && res.data > 0) {
          loadReviews();
          alert("리뷰가 등록되었습니다.");
          document.querySelector(".review-form").style.display = "none";
        } else {
          alert(res.message || "리뷰 등록 실패");
        }
      },
      error: function (xhr) {
        console.error("등록 실패 응답:", xhr.responseText);
        alert("리뷰 등록 실패 (서버 오류)");
      }
    });
  }

// 리뷰 수정, 삭제 버튼 바인딩
  function bindReviewEvents(container) {
    const editBtn = container.querySelector(".review-edit-btn");
    const deleteBtn = container.querySelector(".review-delete-btn");

    if (editBtn) {
      editBtn.addEventListener("click", () => {
        const contentEl = container.querySelector(".review-content");
        const originalContent = contentEl.textContent.trim();
        contentEl.style.display = "none";

        const buttonsDiv = container.querySelector(".review-buttons");
        buttonsDiv.innerHTML = `
          <button class="review-save-btn">저장</button>
          <button class="review-cancel-btn">취소</button>
        `;

        const textarea = document.createElement("textarea");
        textarea.className = "review-edit-input";
        textarea.value = originalContent;
        container.appendChild(textarea);

        buttonsDiv.querySelector(".review-save-btn").addEventListener("click", () => {
          const newContent = textarea.value.trim();
          if (!newContent) {
            alert("리뷰 내용을 입력하세요.");
            return;
          }
          updateReview(container.dataset.reviewId, newContent);
          textarea.remove();
          contentEl.style.display = "block";
          restoreButtons(container);
        });

        buttonsDiv.querySelector(".review-cancel-btn").addEventListener("click", () => {
          textarea.remove();
          contentEl.style.display = "block";
          restoreButtons(container);
        });
      });
    }

    if (deleteBtn) {
      deleteBtn.addEventListener("click", () => {
        if (confirm("리뷰를 삭제하시겠습니까?")) {
          deleteReview(container.dataset.reviewId);
        }
      });
    }
  }

// 수정 완료 or 취소 시 버튼 상태 되돌리기
  function restoreButtons(container) {
    const buttonsDiv = container.querySelector(".review-buttons");
    buttonsDiv.innerHTML = `
      <button class="review-edit-btn">수정</button>
      <button class="review-delete-btn">삭제</button>
    `;
    bindReviewEvents(container);
  }


// 리뷰 수정
  function updateReview(reviewId, reviewText) {
    $.ajax({
      url: `${cpath}/api/${storeUrl}/productdetail/${productId}/review`,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify({ reviewId, reviewText }),
      success: function () {
        loadReviews();
        alert("리뷰가 수정되었습니다.");
      },
      error: function (xhr) {
        console.error(xhr);
        alert("리뷰 수정 실패");
      }
    });
  }

// 리뷰 삭제
  function deleteReview(reviewId) {
    $.ajax({
      url: `${cpath}/api/${storeUrl}/productdetail/${productId}/review?reviewId=${reviewId}`,
      method: "DELETE",
      success: function () {
        loadReviews();
        alert("리뷰가 삭제되었습니다.");
        document.querySelector(".review-form").style.display = "block";
      },
      error: function (xhr) {
        console.error(xhr);
        alert("리뷰 삭제 실패");
      }
    });
  }
});