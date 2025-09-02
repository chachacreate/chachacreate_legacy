<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>스토어 개설 신청</title>
<link rel="stylesheet" type="text/css"
	href="${cpath}/resources/css/main/sellerJoin.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 상단 배너 -->
		<div class="header-banner">
			<div class="header-content">
				<div class="logo-title-wrapper">
					<img class="logo" src="${cpath}/resources/images/logo.png" />
					<div class="page-title">스토어 개설 신청</div>
				</div>
				<img class="header-illustration"
					src="${cpath}/resources/images/illustration.png" />
			</div>
		</div>

		<div class="seller-container">
			<h2 class="main-title">스토어 개설 신청하기</h2>

			<div class="form-group">
				<div class="field-label-wrapper">
					<div class="div17">스토어 이름</div>
					<div class="required-mark">*</div>
				</div>
				<div class="frame-754">
					<input type="text" id="storeName" class="input-field"
						placeholder="스토어 이름을 입력하세요" />
				</div>
			</div>

			<div class="form-group">
				<div class="field-label-wrapper">
					<div class="div17">스토어 대표사진(로고)</div>
					<div class="required-mark">*</div>
				</div>
				<div class="frame-754" id="uploadBox">
<!-- 					<span id="plusSign">+</span> -->
				</div>
				<input type="file" id="logoImg" accept=".jpg,.jpeg,.png,.gif"
					style="display: none;">
			</div>

			<div class="form-group">
				<div class="field-label-wrapper">
					<div class="div17">스토어 URL</div>
					<div class="required-mark">*</div>
				</div>
				<div class="frame-754">
					<input type="text" id="storeUrl" class="input-field"
						placeholder="스토어 URL은 영문, 숫자, 언더바(_)만 사용 가능하며 3~20자 이내여야 합니다." />
					<div id="urlCheckMsg" style="font-size: 12px; margin-top: 4px;"></div>
				</div>
			</div>

			<div class="form-group">
				<div class="field-label-wrapper">
					<div class="div17">스토어 설명</div>
					<div class="required-mark">*</div>
				</div>
				<textarea class="box" id="storeDetail" placeholder="내용을 입력하세요"></textarea>
				<div class="char-count">1/3000</div>
			</div>

			<div class="form-group consent-section">
				<div class="consent-title-wrapper">
					<span class="consent-title">정보를 수집하고 이용하는데 동의합니다.</span>
					<iconify-icon icon="mdi:open-in-new" style="font-size: 16px;"></iconify-icon>
					<span class="required-mark">*</span>
				</div>
				<div class="consent-subtext">2년 이내 정보는 파기됩니다.</div>
				<label class="checkbox-wrapper"> <input type="checkbox"
					class="checkbox-input" id="agreeCheckbox" /> <span
					class="checkbox-label">동의합니다.</span>
				</label>
			</div>

			<div class="frame-752">
				<div class="component-3">
					<button class="close-btn" type="button">신청하기</button>
				</div>
			</div>
		</div>
	</div>

	<script>
	let logoFile = null; // 로고 파일 객체 저장용
	let isUrlAvailable = false;
	
	$(()=>{
		//------------스토어 로고 이미지 업로드 및 미리보기-------------------
		const $uploadBox = $('#uploadBox');
		const $logoInput = $('#logoImg');
		
		// 클릭하면 file input 열기
		$uploadBox.on('click', function () {
			$logoInput.click();
		});
		
		// 파일 선택 시
		$logoInput.on('change', function (e) {
			const file = this.files[0];
			if (!file) return;

			const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
			const fileName = file.name.toLowerCase();
			const extension = fileName.split('.').pop();

			if (!allowedExtensions.includes(extension)) {
				alert('jpg, jpeg, png, gif 형식의 이미지 파일만 업로드할 수 있습니다.');
				$(this).val('');
				return;
			}

			// 파일 객체 저장
			logoFile = file;

			// FileReader로 미리보기
			const reader = new FileReader();
			reader.onload = function(ev) {
			    $uploadBox.html(
			        `<img src="\${ev.target.result}"
			        style="width: 100%; height: 100%; object-fit: cover;">`
			    );
			};
			reader.readAsDataURL(file);
		});
		
		//-----------------텍스트 길이 체크--------------		
		$('.box').on('input', function() {
			const maxLength = 3000;
			const currentLength = $(this).val().length;
			const charCountText = currentLength + '/' + maxLength;
			
			// 같은 부모요소 내의 .char-count에 글자수 업데이트
			$(this).siblings('.char-count').text(charCountText);

			// 3000자 초과시 자르기
			if (currentLength > maxLength) {
				$(this).val($(this).val().substring(0, maxLength));
				$(this).siblings('.char-count').text(maxLength + '/' + maxLength);
			}
		});
		
		//------------------실시간 storeUrl 체크-------------------
		$('#storeUrl').on('keyup', function () {
			console.log("storeUrl 작성 발생됨");
			const storeUrl = $(this).val().trim();
			const urlRegex = /^[a-zA-Z0-9_]{3,20}$/;

			if (!urlRegex.test(storeUrl)) {
				$('#urlCheckMsg').text('❌ 올바른 형식이 아닙니다. (영문/숫자/언더바, 3~20자)').css('color', 'red');
				isUrlAvailable = false;
				return;
			}

			$.ajax({
				url: '${cpath}/legacy/main/store/checkurl',
				method: 'GET',
				data: { storeUrl: storeUrl },
				success: function (response) {
					if (response === true) {
						$('#urlCheckMsg').text('✅ 사용 가능한 URL입니다.').css('color', 'green');
						isUrlAvailable = true;
					} else {
						$('#urlCheckMsg').text('❌ 이미 사용 중인 URL입니다.').css('color', 'red');
						isUrlAvailable = false;
					}
				},
				error: function () {
					$('#urlCheckMsg').text('❌ 중복 확인 실패').css('color', 'red');
					isUrlAvailable = false;
				}
			});
		});
	});
	
	//-------------------유효성 검사 및 전송--------------------------------
	$('.close-btn').on('click', function () {
		const storeName = $('#storeName').val().trim();
		const storeUrl = $('#storeUrl').val().trim();
		const storeDetail = $('#storeDetail').val().trim();
		const agreeChecked = $('#agreeCheckbox').is(':checked');
		
		// 유효성 검사
		if (!storeName) {
			alert("스토어 이름을 입력해주세요.");
			$('#storeName').focus();
			return;
		}
		if (!logoFile) {
			alert("스토어 로고 이미지를 선택해주세요.");
			$('#logoImg').focus();
			return;
		}
		if (!storeUrl) {
			alert("스토어 URL을 입력해주세요.");
			$('#storeUrl').focus();
			return;
		}
		if (!isUrlAvailable) {
			alert("사용 가능한 스토어 URL을 입력해주세요.");
			$('#storeUrl').focus();
			return;
		}
		if (!storeDetail) {
			alert("스토어 설명을 입력해주세요.");
			$('#storeDetail').focus();
			return;
		}
		if (!agreeChecked) {
			alert("개인정보 수집 및 이용에 동의해야 합니다.");
			return;
		}

		// FormData 생성 및 전송
		const formData = new FormData();
		formData.append('storeName', storeName);
		formData.append('storeUrl', storeUrl);
		formData.append('storeDetail', storeDetail);
		formData.append('logoImg', logoFile);

		$.ajax({
			url: '${cpath}/legacy/main/store/openform',
			method: 'POST',
			data: formData,
			processData: false,
			contentType: false,
			success: function (response) {
				alert('스토어 신청이 완료되었습니다.');
				location.href = '${cpath}/' + storeUrl;
			},
			error: function (xhr) {
				alert('오류 발생: ' + xhr.responseText);
			}
		});
	});
	</script>
</body>
</html>