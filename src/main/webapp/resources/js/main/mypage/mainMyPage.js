$(function () {

  const pathSegments = window.location.pathname.split('/');
  const storeUrl = pathSegments.includes('mypage') ? pathParts[pathParts.indexOf('mypage') - 1] : 'default';

  const checkObj = {
    passwordValid: false,
    passwordMatch: false,
    addressValid: false
  };
  
  let originalMemberData = null;  // 회원 기본정보 저장용
  let originalAddrData = null;    // 주소 정보 저장용

  // 회원 정보(+기본 배송지) 불러오기
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/mypage`,
    type: "GET",
    dataType: "json",
    success: function (res) {
      if (res.status === 200) {
        const member = res.data;
        
        originalMemberData = member;

        $('.name').val(member.memberName);
        $('.phone').val(member.memberPhone);
        $('.email').val(member.memberEmail);

        $('.password').val('');
        $('.password-ok').val('');

        // 기본 배송지 조회 API
        $.ajax({
          url: `${cpath}/legacy/${storeUrl}/mypage/order/addr`,
          type: "GET",
          dataType: "json",
          success: function (addrRes) {
            if (addrRes.status === 200 && addrRes.data) {
              const addr = addrRes.data;
              originalAddrData = addr;
              
              $('.post-num').val(addr.postNum);
              $('.address').val(addr.addressRoad + (addr.addressExtra ? ' ' + addr.addressExtra : ''));
              $('.address-detail').val(addr.addressDetail);
              $('.address-road').val(addr.addressRoad);
              $('.address-extra').val(addr.addressExtra);
              checkObj.addressValid = true;
            }
          },
          error: function () {
            console.log("기본 배송지 요청 중 오류 발생");
          }
        });
      } else {
        alert("회원 정보를 불러오지 못했습니다.");
      }
    },
    error: function () {
      alert("회원 정보 요청 중 오류 발생");
    }
  });

  // 주소 검색 API (Daum 우편번호)
  $('.search-btn').click(function () {
    new daum.Postcode({
      oncomplete: function (data) {
        let addr = '';
        let extraAddr = '';

        if (data.userSelectedType === 'R') {
          addr = data.roadAddress;
        } else {
          addr = data.jibunAddress;
        }

        if (data.userSelectedType === 'R') {
          if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
            extraAddr += data.bname;
          }
          if (data.buildingName !== '' && data.apartment === 'Y') {
            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
          }
          if (extraAddr !== '') {
            extraAddr = ' (' + extraAddr + ')';
          }
          $('.address-extra').val(extraAddr);
        } else {
          $('.address-extra').val('');
        }

        $('.post-num').val(data.zonecode);
        $('.address-road').val(addr);
        $('.address-extra').val(extraAddr);
        $('.address').val(addr + (extraAddr ? ' ' + extraAddr : ''));
        $('.address-detail').focus();

        checkObj.addressValid = true;
      }
    }).open();
  });

  // 비밀번호 검증
  function validatePassword(pwd) {
    const specialChars = `!\"#$%&'()*+,-./:;<=>?@[\\]^_\`{|}~`;
    const specialPattern = new RegExp("[" + specialChars.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') + "]");

    if (pwd.length < 8) return false;
    if (!/[a-zA-Z]/.test(pwd)) return false;
    if (!/[0-9]/.test(pwd)) return false;
    if (!specialPattern.test(pwd)) return false;
    return true;
  }

  $('.password').on('input', function () {
    const pwd = $(this).val();
    checkObj.passwordValid = validatePassword(pwd);
    const pwdConfirm = $('.password-ok').val();
    checkObj.passwordMatch = (pwd === pwdConfirm && pwd.length > 0);
  });

  $('.password-ok').on('input', function () {
    const pwdConfirm = $(this).val();
    const pwd = $('.password').val();
    checkObj.passwordMatch = (pwd === pwdConfirm && pwd.length > 0);
  });
	
	// 내 정보 수정 저장 버튼 클릭 시
	$('.info-form').on('submit', function (e) {
	  e.preventDefault();
	
	  const pwd = $('.password').val().trim();
	  const pwdConfirm = $('.password-ok').val().trim();
	
	  const isPasswordChanged = !!pwd; // 비밀번호 입력 여부
	  const isAddressChanged = (
	    originalAddrData == null || // 기존 데이터 없음
	    $('.post-num').val() !== originalAddrData.postNum ||
	    $('.address-road').val() !== originalAddrData.addressRoad ||
	    $('.address-detail').val() !== originalAddrData.addressDetail ||
	    $('.address-extra').val() !== originalAddrData.addressExtra
	  );
	
	  // 비밀번호 수정이 있는 경우만 처리
	  if (isPasswordChanged) {
	    if (!checkObj.passwordValid) {
	      alert("비밀번호는 8자 이상이며 영문, 숫자, 특수문자를 포함해야 합니다.");
	      $('.password').focus();
	      return;
	    }
	    if (!checkObj.passwordMatch) {
	      alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
	      $('.password-ok').focus();
	      return;
	    }
	
	    const memberPwd = { memberPwd: pwd };
	
	    $.ajax({
	      url: `${cpath}/legacy/${storeUrl}/mypage/update/password`,
	      type: "POST",
	      contentType: "application/json; charset=UTF-8",
	      data: JSON.stringify(memberPwd),
	      success: function (res) {
	        if (res.status === 200) {
	          alert("비밀번호가 성공적으로 수정되었습니다.");
	          $('.password').val('');
	          $('.password-ok').val('');
	          checkObj.passwordValid = false;
	          checkObj.passwordMatch = false;
	        } else {
	          alert("비밀번호 수정 실패: " + res.message);
	        }
	      },
	      error: function (xhr) {
	        alert("비밀번호 수정 중 오류가 발생했습니다: " + xhr.responseText);
	      }
	    });
	  }
	
	  // 주소 수정이 있는 경우만 처리
	  if (isAddressChanged) {
	    if (!$('.post-num').val() || !$('.address-road').val()) {
	      alert("우편번호와 주소를 모두 입력해주세요.");
	      return;
	    }
	
	    const addrData = {
	      postNum: $('.post-num').val(),
	      addressRoad: $('.address-road').val(),
	      addressDetail: $('.address-detail').val(),
	      addressExtra: $('.address-extra').val()
	    };
	
	    $.ajax({
	      url: `${cpath}/legacy/${storeUrl}/mypage/order/addr/update`,
	      type: "POST",
	      contentType: "application/json; charset=UTF-8",
	      data: JSON.stringify(addrData),
	      success: function (res) {
	        if (res.status === 200) {
	          alert("주소가 성공적으로 수정되었습니다.");
	        } else {
	          alert("주소 수정 실패: " + res.message);
	        }
	      },
	      error: function (xhr) {
	        alert("주소 수정 중 오류가 발생했습니다: " + xhr.responseText);
	      }
	    });
	  }
	});

  
    $('.cancel-btn').on('click', function () {
    if (originalMemberData) {
      $('.name').val(originalMemberData.memberName);
      $('.phone').val(originalMemberData.memberPhone);
      $('.email').val(originalMemberData.memberEmail);

      $('.password').val('');
      $('.password-ok').val('');
      checkObj.passwordValid = false;
      checkObj.passwordMatch = false;
    }
    if (originalAddrData) {
      $('.post-num').val(originalAddrData.postNum);
      $('.address').val(originalAddrData.addressRoad + (originalAddrData.addressExtra ? ' ' + originalAddrData.addressExtra : ''));
      $('.address-detail').val(originalAddrData.addressDetail);
      $('.address-road').val(originalAddrData.addressRoad);
      $('.address-extra').val(originalAddrData.addressExtra);
      checkObj.addressValid = true;
    }
  });

});
