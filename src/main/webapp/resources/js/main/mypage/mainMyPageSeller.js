$(function () {
  // 상태 저장 객체 및 변수
  const checkObj = { accountname: false };
  let savedAccountNum = '';
  let savedAccountBankCode = '';
  let originalSellerData = {};

  // 초기 상태 설정
  $('.payment-form').hide();
  $('#sellerInfoBtn').hide();
  $('#accountSubmit').hide();
  $('#accountEditBtn').hide();
  $('#sellerFormActions').hide();

  // 은행명 ↔ 은행코드 매핑 객체
  const bankCodeToNameMap = {
    '004': '국민은행',
    '020': '우리은행',
    '088': '신한은행',
    '003': '기업은행',
    '023': 'SC제일은행',
    '011': '농협은행',
    '005': '외환은행',
    '090': '카카오뱅크',
    '032': '부산은행',
    '071': '우체국',
    '031': '대구은행',
    '037': '전북은행',
    '035': '제주은행',
    '007': '수협은행',
    '027': '씨티은행',
    '039': '경남은행'
  };

  function getBankNameByCode(code) {
    return bankCodeToNameMap[code] || '알 수 없는 은행';
  }

  function getBankCodeByName(name) {
    for (const code in bankCodeToNameMap) {
      if (bankCodeToNameMap[code] === name) {
        return code;
      }
    }
    return '';
  }

  // 판매자 정보 조회
  $.ajax({
    url: `${cpath}/api/main/sell/info`,
    method: 'GET',
    dataType: 'json',
    success: function (res) {
      if (res.status === 200 && res.data) {
        const seller = res.data;

        // 기존 계좌번호 및 은행코드 저장
        savedAccountNum = seller.account || '';
        savedAccountBankCode = getBankCodeByName(seller.accountBank) || '';

        // 취소시 원상 복구를 위한 정보 저장
        originalSellerData = Object.assign({}, seller);

        // 판매자 정보 버튼 보이기
        $('#sellerInfoBtn').show();

        // 은행 선택박스 숨기고 은행명 표시
        $('#bank-section').hide();
        $('#bankNameDisplay').remove();
        $('<input type="text" id="bankNameDisplay" style="font-weight:bold;" disabled />')
          .val(seller.accountBank || '알 수 없는 은행')
          .insertAfter('#bank-section');

        // 계좌번호, 예금주명 세팅 및 비활성화
        $('#account-notice').hide();
        $('#accountnum').val(savedAccountNum).prop('disabled', true);
        $('#accountname').val(seller.accountOwner || $('#account-owner').val()).prop('disabled', true);

        // 프로필 이력, 글자수 세팅
        $('.career-text').val(seller.profileInfo || '');
        $('.char-count').text(`${($('.career-text').val()).length}/150`);

        // 이미지 미리보기 처리
        if (seller.profileImageName) {
          $('#previewBox').html(
            `<img src="${cpath}/resources/profileImages/${seller.profileImageName}" 
                   style="width: 100%; height: 100%; object-fit: cover;">`
          );
        } else {
          $('#previewBox').html('+');
        }

        // 수정 버튼 보이기, 인증 버튼 숨기기
        $('#accountEditBtn').show();
        $('#accountSubmit').hide();

      } else {
        // 판매자 정보 없으면 신규 등록 모드
        $('#sellerInfoBtn').hide();

        $('#bankselect').show().prop('disabled', false);
        $('#bankNameDisplay').remove();
        $('#accountnum').val('').prop('disabled', false);
        $('#accountname').val($('#account-owner').val()).prop('disabled', true);

        $('#accountSubmit').show();
        $('#accountEditBtn').hide();
        $('.career-text').val('');
        $('.char-count').text('0/150');
        $('#previewBox').html('+');

        savedAccountNum = '';
        savedAccountBankCode = '';
        originalSellerData = {};
      }

      // 은행 select 초기값 설정 (수정 모드에서 사용)
      if (savedAccountBankCode) {
        $('#bankselect').val(savedAccountBankCode);
      } else {
        $('#bankselect').val('');
      }
    },
    error: function () {
      alert('판매자 정보를 불러오는 중 오류가 발생했습니다.');
    }
  });

  // 판매자 정보 버튼 토글
  $('#sellerInfoBtn').on('click', function () {
    $('.payment-form').slideToggle(200);
    $('#sellerFormActions').slideToggle(200);
  });

  // 수정 버튼 클릭 시 수정 모드 활성화
  $('#accountEditBtn').on('click', function () {
    $('#bank-section').show().prop('disabled', false);
    $('#bankNameDisplay').hide();

    $('#accountnum').prop('disabled', false);
    $('#accountname').prop('readonly', true);

    $('#accountSubmit').show();
    $(this).hide();

    checkObj.accountname = false; // 수정 후 인증 필요
  });

  // 계좌 인증 버튼 동작 (예시)
  $('#accountSubmit').on('click', function () {
    const bank_code = $('#bankselect').val();
    const bank_num = $('#accountnum').val();

    if (!bank_code || !bank_num) {
      alert('은행과 계좌번호를 모두 입력해주세요.');
      return;
    }

    $.ajax({
      url: `${cpath}/api/checkAccount`,
      method: 'GET',
      data: { bank_code, bank_num },
      success: function (res) {
        if (res.bankHolderInfo) {
          $('#accountname').val(res.bankHolderInfo);
          const owner = $('#account-owner').val();

          if (owner === res.bankHolderInfo) {
            checkObj.accountname = true;
            $('#bankselect').prop('disabled', true);
            $('#accountnum').prop('disabled', true);
            $('#accountSubmit').hide();
            $('#accountEditBtn').show();
          } else {
            alert('예금주명이 로그인 사용자와 다릅니다.');
            checkObj.accountname = false;
          }
        } else {
          alert('예금주 정보를 찾을 수 없습니다.');
        }
      },
      error: function () {
        alert('예금주 조회 중 오류가 발생했습니다.');
      }
    });
  });

  // 전체 저장 버튼 클릭
  $('#saveAllBtn').on('click', function () {
    const currentAccountNum = $('#accountnum').val(); // 현재 입력된 계좌번호
    const currentBankCode = $('#bankselect').val(); // 현재 선택된 은행 코드
    const currentBankName = $('#bankselect option:selected').text(); // 현재 선택된 은행명

    // 계좌번호가 변경되었는데 인증되지 않았다면 저장 막기
    if ((currentAccountNum !== savedAccountNum || currentBankCode !== savedAccountBankCode) && !checkObj.accountname) {
      alert('계좌 인증을 먼저 완료해주세요.');
      return;
    }

    // 보낼 데이터 객체 만들기 (은행명으로 서버에 전달)
    const dataToSend = {
      account: currentAccountNum,
      accountBank: currentBankName,
      profileInfo: $('.career-text').val()
    };

    $.ajax({
      url: `${cpath}/api/main/sell/info`,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(dataToSend),
      success: function () {
        alert('판매자 정보가 성공적으로 저장되었습니다.');

        // 저장된 값 업데이트
        savedAccountNum = currentAccountNum;
        savedAccountBankCode = currentBankCode;
        checkObj.accountname = true;

        location.reload();
      },
      error: function () {
        alert('판매자 정보 저장 중 오류가 발생했습니다.');
      }
    });
  });

  // 저장 취소 버튼 클릭 시 원래 상태로 복원
  $('.cancel-payment').on('click', function () {
    if (!originalSellerData || !originalSellerData.account) return;

    // 계좌 정보 복원
    $('#accountnum').val(originalSellerData.account).prop('disabled', true);
    $('#accountname').val(originalSellerData.accountOwner).prop('disabled', true);

    // 은행명 표시 및 select 상태 복원
    $('#bankNameDisplay').val(originalSellerData.accountBank || '알 수 없는 은행').show();
    $('#bankselect').val(getBankCodeByName(originalSellerData.accountBank) || '').hide();

    // 이력 복원
    $('.career-text').val(originalSellerData.profileInfo || '');
    $('.char-count').text(`${($('.career-text').val()).length}/150`);

    // 이미지 복원
    if (originalSellerData.profileImageName) {
      $('#previewBox').html(
        `<img src="${cpath}/resources/profileImages/${originalSellerData.profileImageName}" 
           style="width: 100%; height: 100%; object-fit: cover;">`
      );
    } else {
      $('#previewBox').html('+');
    }

    // 버튼 상태 복원
    $('#accountSubmit').hide();
    $('#accountEditBtn').show();
    $('#bank-section').hide();
    $('#bankNameDisplay').show();

    // 인증 여부 리셋
    checkObj.accountname = true;

    // 저장된 계좌번호, 은행코드도 원복
    savedAccountNum = originalSellerData.account || '';
    savedAccountBankCode = getBankCodeByName(originalSellerData.accountBank) || '';
  });

  // 글자수 카운트 및 제한
  $('.career-text').on('input', function () {
    let val = $(this).val();
    if (val.length > 150) {
      val = val.substring(0, 150);
      $(this).val(val);
    }
    $('.char-count').text(`${val.length}/150`);
  });

});
