<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>페이지를 찾을 수 없습니다</title>
  <style>
    @charset "UTF-8";

    body {
      margin: 0;
      padding: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #F8F6EC;
      color: #2d4739;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      overflow: hidden;
    }

    .error-container {
      text-align: center;
      padding: 30px;
      max-width: 480px;
      width: 90%;
      animation: fadeIn 1.2s ease-in;
    }

    .error-image {
      width: 80%;
      max-width: 300px;
      margin-bottom: 30px;
      animation: breathe 2.5s ease-in-out infinite;
    }

    h1 {
      font-size: 24px;
      margin: 10px 0;
      opacity: 0;
      animation: fadeInText 1.5s ease forwards;
      animation-delay: 0.5s;
    }

    p {
      font-size: 16px;
      line-height: 1.6;
      color: #555;
      margin-bottom: 30px;
      opacity: 0;
      animation: fadeInText 1.5s ease forwards;
      animation-delay: 0.8s;
    }

    .home-button {
      display: inline-block;
      padding: 12px 24px;
      background-color: #6e8b7c;
      color: #fff;
      text-decoration: none;
      border-radius: 8px;
      font-size: 16px;
      transition: all 0.3s ease;
      animation: popUp 0.7s ease 1.5s forwards;
      transform: scale(0.9);
      opacity: 0;
    }

    .home-button:hover {
      background-color: #56705e;
      transform: scale(1.05);
    }

    /* 애니메이션 정의 */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeInText {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes popUp {
      from { transform: scale(0.9); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }

    @keyframes breathe {
      0%, 100% {
        transform: scale(1);
      }
      50% {
        transform: scale(1.10);
      }
    }
  </style>
</head>
<body>
  <div class="error-container">
    <img src="${pageContext.servletContext.contextPath}/resources/images/error/errorpage_500.png" alt="404 로고" class="error-image">
    <h1>죄송합니다. 페이지를 찾을 수 없습니다.</h1>
    <p>존재하지 않는 주소를 입력하셨거나,<br>요청하신 페이지의 주소가 변경, 삭제되어 찾을 수 없습니다.</p>
    <a href="${pageContext.servletContext.contextPath}/main" class="home-button">홈으로 돌아가기</a>
  </div>
</body>
</html>
