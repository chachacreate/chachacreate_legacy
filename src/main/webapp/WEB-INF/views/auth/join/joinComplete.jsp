<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 완료</title>
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- Pretendard 폰트 (CDN 연결) -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css" />
  
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            brand: {
              primary: '#2d4739',
              light: '#3d5749',
              lighter: '#5d7769',
              lightest: '#e8ede9'
            }
          },
          fontFamily: {
            'pretendard': ['Pretendard Variable', 'sans-serif']
          }
        }
      }
    }
  </script>
  
  <style>
    body {
      font-family: 'Pretendard Variable', sans-serif;
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    }

    /* 메인 컨테이너 향상 */
    .max-w-4xl {
      box-shadow: 
        0 20px 25px -5px rgba(0, 0, 0, 0.05),
        0 10px 10px -5px rgba(0, 0, 0, 0.02);
      border-radius: 20px;
      overflow: hidden;
    }

    /* 헤더 향상 */
    .bg-brand-primary {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      position: relative;
    }

    .bg-brand-primary::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><pattern id="grain" width="100" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="%23ffffff" opacity="0.05"/><circle cx="30" cy="5" r="0.5" fill="%23ffffff" opacity="0.03"/><circle cx="70" cy="15" r="0.8" fill="%23ffffff" opacity="0.04"/></pattern></defs><rect width="100" height="20" fill="url(%23grain)"/></svg>');
      opacity: 0.1;
    }
    
    /* 성공 애니메이션 */
    .success-animation {
      animation: bounceIn 0.8s ease-out;
    }
    
    @keyframes bounceIn {
      0% {
        opacity: 0;
        transform: scale(0.3) translateY(20px);
      }
      50% {
        opacity: 1;
        transform: scale(1.05) translateY(-5px);
      }
      70% {
        transform: scale(0.9) translateY(2px);
      }
      100% {
        opacity: 1;
        transform: scale(1) translateY(0px);
      }
    }
    
    /* 체크마크 애니메이션 향상 */
    .check-icon {
      width: 96px;
      height: 96px;
      background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 52px;
      color: white;
      margin: 0 auto 32px;
      animation: checkPulse 1.2s ease-out;
      box-shadow: 
        0 12px 40px rgba(34, 197, 94, 0.4),
        0 6px 20px rgba(34, 197, 94, 0.2);
      position: relative;
    }

    .check-icon::before {
      content: '';
      position: absolute;
      inset: -8px;
      border-radius: 50%;
      background: linear-gradient(135deg, rgba(34, 197, 94, 0.1) 0%, rgba(22, 163, 74, 0.1) 100%);
      animation: pulse 2s infinite;
    }
    
    @keyframes checkPulse {
      0% {
        transform: scale(0);
        opacity: 0;
      }
      50% {
        transform: scale(1.15);
      }
      100% {
        transform: scale(1);
        opacity: 1;
      }
    }

    @keyframes pulse {
      0%, 100% {
        opacity: 0.5;
        transform: scale(1);
      }
      50% {
        opacity: 0.8;
        transform: scale(1.1);
      }
    }
    
    /* 완료 박스 스타일 향상 */
    .complete-box {
      background: white;
      border: 3px solid #22c55e;
      border-radius: 24px;
      padding: 56px 40px;
      text-align: center;
      max-width: 560px;
      margin: 56px auto;
      box-shadow: 
        0 20px 60px rgba(0, 0, 0, 0.08),
        0 8px 25px rgba(34, 197, 94, 0.15);
      position: relative;
      overflow: hidden;
    }

    .complete-box::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, #22c55e 0%, #16a34a 50%, #22c55e 100%);
      animation: shimmer 2s infinite;
    }

    @keyframes shimmer {
      0% { background-position: -200% 0; }
      100% { background-position: 200% 0; }
    }
    
    .complete-title {
      font-size: 32px;
      font-weight: 800;
      color: #1f2937;
      margin-bottom: 20px;
      letter-spacing: -0.05em;
      background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    
    .complete-msg {
      font-size: 20px;
      color: #4b5563;
      margin-bottom: 40px;
      line-height: 1.6;
      font-weight: 500;
      letter-spacing: -0.025em;
    }
    
    .btn-move {
      background: linear-gradient(135deg, #2d4739 0%, #3d5749 100%);
      color: white;
      border: 2px solid transparent;
      border-radius: 16px;
      padding: 20px 40px;
      font-size: 18px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      width: 100%;
      max-width: 320px;
      box-shadow: 
        0 6px 20px rgba(45, 71, 57, 0.25),
        0 3px 10px rgba(45, 71, 57, 0.15);
      letter-spacing: -0.025em;
      position: relative;
      overflow: hidden;
    }

    .btn-move::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      transition: left 0.5s ease;
    }

    .btn-move:hover::before {
      left: 100%;
    }
    
    .btn-move:hover {
      background: linear-gradient(135deg, #3d5749 0%, #4d6759 100%);
      transform: translateY(-3px);
      box-shadow: 
        0 10px 30px rgba(45, 71, 57, 0.3),
        0 6px 15px rgba(45, 71, 57, 0.2);
    }

    .btn-move:active {
      transform: translateY(-1px);
      box-shadow: 
        0 4px 15px rgba(45, 71, 57, 0.25);
    }

    /* 축하 배경 효과 */
    .celebration-bg {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      pointer-events: none;
      overflow: hidden;
    }

    .confetti {
      position: absolute;
      width: 8px;
      height: 8px;
      background: #22c55e;
      border-radius: 50%;
      animation: confetti-fall 3s infinite linear;
      opacity: 0.7;
    }

    .confetti:nth-child(1) { left: 10%; animation-delay: 0s; background: #22c55e; }
    .confetti:nth-child(2) { left: 20%; animation-delay: 0.5s; background: #3b82f6; }
    .confetti:nth-child(3) { left: 30%; animation-delay: 1s; background: #f59e0b; }
    .confetti:nth-child(4) { left: 40%; animation-delay: 1.5s; background: #ef4444; }
    .confetti:nth-child(5) { left: 50%; animation-delay: 2s; background: #8b5cf6; }
    .confetti:nth-child(6) { left: 60%; animation-delay: 0.3s; background: #06b6d4; }
    .confetti:nth-child(7) { left: 70%; animation-delay: 0.8s; background: #84cc16; }
    .confetti:nth-child(8) { left: 80%; animation-delay: 1.3s; background: #f97316; }
    .confetti:nth-child(9) { left: 90%; animation-delay: 1.8s; background: #ec4899; }

    @keyframes confetti-fall {
      0% {
        transform: translateY(-100vh) rotate(0deg);
        opacity: 1;
      }
      100% {
        transform: translateY(100vh) rotate(360deg);
        opacity: 0;
      }
    }
    
    /* 반응형 조정 */
    @media (max-width: 640px) {
      .complete-box {
        margin: 32px auto;
        padding: 40px 28px;
        border-radius: 20px;
      }
      
      .complete-title {
        font-size: 26px;
      }
      
      .complete-msg {
        font-size: 18px;
        margin-bottom: 32px;
      }
      
      .check-icon {
        width: 80px;
        height: 80px;
        font-size: 42px;
        margin-bottom: 24px;
      }

      .btn-move {
        padding: 16px 32px;
        font-size: 16px;
        max-width: 280px;
      }
    }
  </style>
</head>
<body class="bg-gray-50 min-h-screen font-pretendard">
  <!-- 축하 배경 효과 -->
  <div class="celebration-bg">
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
  </div>

  <!-- 컨테이너 -->
  <div class="max-w-4xl mx-auto bg-white shadow-sm min-h-screen">
    
    <!-- 상단 헤더 -->
    <div class="bg-brand-primary text-white py-6 px-4 sm:px-8">
      <div class="flex items-center justify-between relative z-10">
        <h1 class="text-xl sm:text-2xl font-bold">회원가입하기</h1>
        <div class="w-8 h-8 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
          <span class="text-sm font-medium">3</span>
        </div>
      </div>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="p-4 sm:p-8">
      
      <!-- 진행 단계 표시 -->
      <div class="mb-8">
        <div class="flex items-center justify-between relative">
          <!-- 진행바 배경 -->
          <div class="absolute top-4 left-0 w-full h-1 bg-gray-200 rounded-full"></div>
          <div class="absolute top-4 left-0 w-3/4 h-1 bg-brand-primary rounded-full"></div>
          
          <!-- 단계들 -->
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">01</div>
            <span class="text-xs sm:text-sm text-brand-primary">약관동의</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">02</div>
            <span class="text-xs sm:text-sm text-brand-primary">회원정보입력</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-brand-primary text-white rounded-full flex items-center justify-center text-sm font-medium mb-2">03</div>
            <span class="text-xs sm:text-sm font-medium text-brand-primary">완료</span>
          </div>
          
          <div class="flex flex-col items-center relative z-10 bg-white px-2">
            <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center text-sm font-medium mb-2">04</div>
            <span class="text-xs sm:text-sm text-gray-500">판매자정보입력</span>
          </div>
        </div>
      </div>
    
      <!-- 회원가입 완료 안내 영역 -->
      <div class="complete-box success-animation">
        <div class="check-icon">✔</div>
        <div class="complete-title">회원가입 완료</div>
        <div class="complete-msg">${sessionScope.loginMember.memberName}님! 반갑습니다.</div>
        <button class="btn-move" onclick="location.href='${cpath}/main'">
          쇼핑몰 이동하기
        </button>
      </div>
      
    </div>
  </div>
</body>
</html>