<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 판매자 스토어정보</title>
<%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/sellerInfo.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
</head>
<body>
<div class="content-wrapper">
 <div class="side-padding"></div>
   <%@ include file="/common/store_seller_sidenav.jsp" %>

  <div class="main-area">


      <main class="content">
        <div class="content-inner">
		  <h2>나의 스토어 정보</h2>
		  
			<div class="store-info-wrapper">
			  <div class="profile-section">
			    <!-- 왼쪽: 스토어 이미지 및 이름 -->
			    <div class="profile-img">
			      <img src="${cpath}/resources/productImages/${logoImg}" alt="스토어 로고" style="height: 80px" />
			    </div>
				  <button type="button" id="photoChangeBtn" class="div3">사진 수정</button>
				  <input type="file" id="fileInput" accept="image/*" style="display: none;" />
			    <div class="store-name">${storeName}</div>
			  </div>
			 
			<div class="frame-1156">
	          <div class="frame-1079">
  <div class="section-title-wrapper">
    <div class="section-title">내 스토어 정보</div>
    <div class="section-line"></div>
  </div>
  <div class="frame-1150">
    <div class="frame-1153">
      <div class="iconamoon-store-thin">
        <iconify-icon icon="mdi:store" width="48" height="48"/>
      </div>
      <div class="div4">스토어 소개</div>
    </div>
    <textarea class="info-textarea" id="store-detail" name="storeDetail" placeholder="스토어 소개를 입력해주세요"></textarea>
  </div>
</div>
	          </div>
	          <div class="frame-1080">
  <div class="section-title-wrapper">
    <div class="section-title">판매자 정보</div>
    <div class="section-line"></div>
  </div>

  <div class="frame-11502">
    <div class="frame-1153">
      <iconify-icon icon="mdi:account" width="47" height="47" class="iconoir-user"/>
      <div class="div4">이름</div>
    </div>
    <input type="text" class="info-input" id="member-name" name="memberName" value="${sessionScope.loginMember.memberName}" readonly="readonly" />
  </div>

  <div class="frame-1152">
    <div class="frame-1153">
      <iconify-icon icon="mdi:phone" width="40" height="40"/>
      <div class="div4">연락처</div>
    </div>
    <input type="text" class="info-input" id="member-phone" name="memberPhone" value="" readonly="readonly" />
  </div>

  <div class="frame-11532">
    <div class="frame-1153">
      <iconify-icon icon="mdi:email" width="40" height="40"/>
      <div class="div4">이메일</div>
    </div>
    <input type="email" class="info-input" id="member-email" name="memberEmail" value="" readonly="readonly" />
  </div>
</div>
	          
	          <!-- ✅ 계좌 등록 정보 -->
<div class="frame-1081">
  <div class="section-title-wrapper">
    <div class="section-title">계좌 정보</div>
    <div class="section-line"></div>
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:account" width="40" height="40"/>
      <div class="div4">이름</div>
    </div>
    <input type="text" id="account-owner" class="info-input" readonly value="${sessionScope.loginMember.memberName}" />
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:bank" width="40" height="40"/>
      <div class="div4">은행</div>
    </div>
    <select id="bankselect" class="info-input">
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
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:wallet" width="40" height="40"/>
      <div class="div4">계좌번호</div>
    </div>
    <input type="text" id="accountnum" class="info-input" placeholder="-없이 계좌번호 입력" />
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:badge-account" width="40" height="40"/>
      <div class="div4">예금주명</div>
    </div>
    <input type="text" id="accountname" class="info-input" readonly />
  </div>

  <button type="button" class="account-button" id="accountSubmit">계좌 수정하기</button>
</div>

<!-- ✅ 나의 이력 등록 -->
<div class="frame-1081">
  <div class="section-title-wrapper">
    <div class="section-title">나의 이력 등록</div>
    <div class="section-line"></div>
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:image" width="40" height="40"/>
      <div class="div4">작품 사진</div>
    </div>
    <input type="file" id="fileInput" class="info-input" />
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:text-box" width="40" height="40"/>
      <div class="div4">이력 설명</div>
    </div>
    <textarea class="info-textarea" id="profileInfo" placeholder="이력 설명 (최대 150자)" maxlength="150"></textarea>
  </div>
</div>
	          <div class="button-wrapper">
  <button type="button"id="sellerInfoSubmit" class="edit-button">수정</button>
  <a href="${cpath}/${storeUrl}/seller/close" class="close-button">폐업하기</a>
</div>
	         
		  </div>
		</div>
      </main>

  </div>
  <div class="side-padding"></div>
</div>

<script>

//-----------------사진 파일 실시간 반영(파일명 기준)--------------		
const checkObj = {
  accountname: false,       // 예금주 인증 여부
  storeDetail: false,       // 스토어 소개
  logoImg: false,           // 로고 이미지
  account: false,           // 계좌번호
  accountBank: false,       // 은행
  profileInfo: false        // 이력 설명
};
$('#photoChangeBtn').on('click', function () {
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
	    $('.profile-img').html(`<img src="${cpath}/resources/productImages/\${file.name}" style="max-width: 100%; max-height: 100%; object-fit: contain;">`);
	  };
	  reader.readAsDataURL(file);
	});

$(function() {
	
	function checkmyinfo() {
		const bank_code = $('#bankselect').val();
		const bank_num = $('#accountnum').val();

		if (!bank_code || !bank_num) {
			alert('은행과 계좌번호를 모두 입력해주세요.');
			return;
		}

		$.ajax({
			url : '${cpath}/api/checkAccount',
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

// -----------------------판매자 정보 가져오기---------------------
$(document).ready(function () {
	const bankMap = {
			  "국민은행": "004",
			  "우리은행": "020",
			  "신한은행": "088",
			  "기업은행": "003",
			  "SC제일은행": "023",
			  "농협은행": "011",
			  "외환은행": "005",
			  "카카오뱅크": "090",
			  "부산은행": "032",
			  "우체국": "071",
			  "대구은행": "031",
			  "전북은행": "037",
			  "제주은행": "035",
			  "수협은행": "007",
			  "씨티은행": "027",
			  "경남은행": "039"
			};

  $.ajax({
    url: "${cpath}/api/${storeUrl}/seller/management/sellerInfo",
    method: "GET",
    contentType: 'application/json',
    success: function (res) {
      if (res.status === 200) {
        const data = res.data;

        // 이미지 및 기본 정보 채우기
        $("#profile-img").attr("src", "${cpath}/resources/productImages/" + data.logoImg);
        $("#store-name").text(data.storeName);
        $("#store-detail").val(data.storeDetail);

        // 판매자 정보
        $("#member-name").val(data.memberName);
        $("#member-email").val(data.memberEmail);
        $("#member-phone").val(data.memberPhone);

        // 계좌 정보
        const selectedBankCode = bankMap[data.accountBank];
		if (selectedBankCode) {
		  $("#bankselect").val(selectedBankCode);
		}
        $("#accountnum").val(data.account);
        $("#accountname").val(data.memberName); // 예금주 = 판매자 이름과 동일
        $("#profileInfo").val(data.profileInfo);
      } else {
        alert("데이터 로드 실패: " + res.message);
      }
    },
    error: function (xhr, status, err) {
      console.error("에러 발생:", err);
      alert("서버 통신 중 오류가 발생했습니다.");
    }
  });
});

$('#sellerInfoSubmit').on('click', function () {
	if (!validateSellerInputs()) return; // 유효성 통과 못하면 return

    const storeDetail = $('#store-detail').val().trim();
    const logoImg = $('#fileInput')[0].files[0] ? $('#fileInput')[0].files[0].name : null;
    const account = $('#accountnum').val().trim();
    const accountBank = $('#bankselect option:selected').text(); // '국민은행' 등
    const profileInfo = $('#profileInfo').val().trim();

    // 서버에 보낼 DTO 데이터 구성
    const data = {
        storeDetail: storeDetail,
        logoImg: logoImg,
        account: account,
        accountBank: accountBank,
        profileInfo: profileInfo
    };

    $.ajax({
        url: '${cpath}/api/${storeUrl}/seller/management/sellerInfo',
        method: 'PUT',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (res) {
            if (res.status === 200) {
                alert('정보가 성공적으로 수정되었습니다.');
                location.reload();
            } else {
                alert('수정 실패: ' + res.message);
            }
        },
        error: function (xhr, status, err) {
            console.error('요청 실패:', err);
            alert('서버 오류가 발생했습니다.');
        }
    });
});
function validateSellerInputs() {
	  let isValid = true;

	  const storeDetail = $('#store-detail').val().trim();
	  const accountnum = $('#accountnum').val().trim();
	  const bank = $('#bankselect').val();
	  const profileInfo = $('#profileInfo').val().trim();

	  // 스토어 소개
	  if (!storeDetail) {
	    alert("스토어 소개를 입력해주세요.");
	    $('#store-detail').focus();
	    checkObj.storeDetail = false;
	    return false;
	  } else {
	    checkObj.storeDetail = true;
	  }

	  // 은행 선택
	  if (!bank) {
	    alert("은행을 선택해주세요.");
	    $('#bankselect').focus();
	    checkObj.bankselect = false;
	    return false;
	  } else {
	    checkObj.bankselect = true;
	  }

	  // 계좌번호 입력
	  if (!accountnum) {
	    alert("계좌번호를 입력해주세요.");
	    $('#accountnum').focus();
	    checkObj.accountnum = false;
	    return false;
	  } else {
	    checkObj.accountnum = true;
	  }

	  // 계좌 인증 여부
	  if (!checkObj.accountname) {
	    alert("계좌 인증을 먼저 완료해주세요.");
	    $('#accountnum').focus();
	    return false;
	  }

	  // 이력 설명
	  if (!profileInfo) {
	    alert("이력 설명을 입력해주세요.");
	    $('#profileInfo').focus();
	    checkObj.profileInfo = false;
	    return false;
	  } else {
	    checkObj.profileInfo = true;
	  }

	  return true; // 모든 조건 통과
	}

</script>

</body>
</html>