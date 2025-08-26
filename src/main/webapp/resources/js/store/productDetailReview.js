document.addEventListener("DOMContentLoaded", () => {
  const pathSegments = window.location.pathname.split("/");
  const storeUrl = pathSegments[pathSegments.length - 3];
  const productId = pathSegments[pathSegments.length - 1];
  const cpath = document.body.getAttribute("data-cpath") || "";

  let orderDetailId = null;
  const loggedInMemberId = window.loggedInMemberId || null;
  let isSeller = false;

  if (!loggedInMemberId) {
    document.querySelector(".review-form").style.display = "none";
  } else {
    const orderDetailUrl = `${cpath}/legacy/${storeUrl}/order/${loggedInMemberId}/products/${productId}/orderdetail`;
    $.ajax({
      url: orderDetailUrl,
      method: "GET",
      dataType: "json",
      success: function (res) {
        if (res.status === 200 && res.data != null) {
          orderDetailId = res.data;
          checkReviewWritable(orderDetailId);
          bindSubmit();
        } else {
          document.querySelector(".review-form").style.display = "none";
        }
      },
      error: function () {
        document.querySelector(".review-form").style.display = "none";
      }
    });
  }

  $.ajax({
    url: `${cpath}/legacy/auth/editable/${productId}`,
    method: "GET",
    dataType: "json",
    success: function(res) {
      if (res.data === true) {
        isSeller = true;
      }
      loadReviews();
    },
    error: function() {
      loadReviews();
    }
  });

  function checkReviewWritable(orderDetailId) {
    $.ajax({
      url: `${cpath}/legacy/${storeUrl}/productdetail/${productId}/review/check`,
      method: "GET",
      data: { orderDetailId },
      dataType: "json",
      success: function (res) {
        const form = document.querySelector(".review-form");
        form.style.display = (res.status === 200 && res.data === true) ? "block" : "none";
      },
      error: function () {
        document.querySelector(".review-form").style.display = "none";
      }
    });
  }

  function loadReviews() {
    $.ajax({
      url: `${cpath}/legacy/${storeUrl}/productdetail/${productId}/review`,
      method: "GET",
      dataType: "json",
      success: function(data) {
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
                ${isMyReview
                  ? `<button class="review-edit-btn">수정</button><button class="review-delete-btn">삭제</button>`
                  : isSeller
                    ? `<button class="review-report-btn" data-review-id="${review.reviewId}">신고</button>`
                    : ""}
              </div>
            </div>
            <div class="review-content">${review.reviewText}</div>
          `;

          reviewList.appendChild(reviewItem);

          if (isMyReview) {
            bindReviewEvents(reviewItem);
          } else if (isSeller) {
            const reportBtn = reviewItem.querySelector(".review-report-btn");
            if (reportBtn) {
              reportBtn.addEventListener("click", function () {
                if (!loggedInMemberId) {
                  alert("로그인이 필요합니다.");
                  location.href = `${cpath}/auth/login`;
                  return;
                }

                const reviewId = this.dataset.reviewId;

                $.ajax({
                  url: `${cpath}/legacy/${storeUrl}/seller/review/member/${reviewId}`,
                  method: "GET",
                  dataType: "json",
                  success: function (res) {
                    if (res.status === 200 && res.data != null) {
                      const reportedMemberId = res.data;
                      $('#reportModal2').data('reported-member-id', reportedMemberId);
                      $('#reportModal2').fadeIn();
                    } else {
                      alert("리뷰 작성자를 찾을 수 없습니다.");
                    }
                  },
                  error: function () {
                    alert("리뷰 작성자 조회 중 오류 발생");
                  }
                });
              });
            }
          }
        });
      },
      error: function(xhr) {
        console.error(xhr);
        alert("리뷰 목록을 불러오지 못했습니다.");
      }
    });
  }

  function bindSubmit() {
    document.getElementById("review-submit-btn").addEventListener("click", () => {
      const content = document.getElementById("review-input").value.trim();
      if (!content) return alert("리뷰 내용을 입력하세요.");
      addReview(content);
      document.getElementById("review-input").value = "";
    });
  }

  function addReview(reviewText) {
    $.ajax({
      url: `${cpath}/legacy/${storeUrl}/productdetail/${productId}/review`,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ reviewText, orderDetailId }),
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
          if (!newContent) return alert("리뷰 내용을 입력하세요.");
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

  function restoreButtons(container) {
    const buttonsDiv = container.querySelector(".review-buttons");
    buttonsDiv.innerHTML = `
      <button class="review-edit-btn">수정</button>
      <button class="review-delete-btn">삭제</button>
    `;
    bindReviewEvents(container);
  }

  function updateReview(reviewId, reviewText) {
    $.ajax({
      url: `${cpath}/legacy/${storeUrl}/productdetail/${productId}/review`,
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

  function deleteReview(reviewId) {
    $.ajax({
      url: `${cpath}/legacy/${storeUrl}/productdetail/${productId}/review?reviewId=${reviewId}`,
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

  $('#cancelReport2').on('click', function () {
    $('#reportModal2').fadeOut();
    $('#reportTitle2').val('');
    $('#reportText2').val('');
  });

  $('#submitReport2').off('click').on('click', function () {
    const title = $('#reportTitle2').val().trim();
    const reason = $('#reportText2').val().trim();
    const reportedMemberId = $('#reportModal2').data('reported-member-id');
    const storeId = product.storeId;
    const memberCheck = 1;

    if (!title || !reason) {
      alert('신고 제목과 사유를 모두 입력하세요.');
      return;
    }

    const reportData = {
      memberId: reportedMemberId,
      storeId: storeId,
      reportTitle: title,
      reportText: reason,
      memberCheck: memberCheck
    };

    $.ajax({
      url: `${cpath}/legacy/${storeUrl}/reportinsert`,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(reportData),
      success: function (res) {
        if (res.status === 201) {
          alert('신고가 접수되었습니다.');
          $('#reportModal2').fadeOut();
          $('#reportTitle2').val('');
          $('#reportText2').val('');
        } else {
          alert('신고 실패: ' + (res.message || '알 수 없는 오류'));
        }
      },
      error: function (xhr) {
        alert('신고 처리 중 오류 발생');
        console.error(xhr);
      }
    });
  });
});
