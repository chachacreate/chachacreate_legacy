<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>채팅방</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/chat.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body>
<div class="wrapper">
  <div class="main-area">
    <div class="content-wrapper">
      
      <!-- 사이드바 -->
      <nav class="sidebar">
        <div class="profile-section" role="button" tabindex="0">
          <img src="_11.png" class="profile-img" />
          <div class="store-name">수제대추고</div>
        </div>
        <ul class="menu-list">
          <li><a href="#"><span class="menu-text">상품등록</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">판매상품관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">주문/발송확인(취소/환불)</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">환불관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">정산관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">문의메시지</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">리뷰관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">스토어관리</span><span class="arrow">></span></a></li>
        </ul>
        <div class="sidebar-footer">
          <button class="btn-go-buyer">구매자페이지 이동</button>
        </div>
      </nav>

      <!-- 메인 콘텐츠 (chat.jsp 내용) -->
      <main class="content">
        <div class="content-inner">
          
          <div class="chat-container">

            <!-- 채팅방 목록 -->
            <div class="chat-sidebar">
              <h2>채팅방</h2>
              <div class="chat-search">
                <input type="text" placeholder="채팅방 검색">
              </div>
              <ul class="chat-room-list">
                <li class="chat-room-item active">
                  <div class="chat-room-name">차팀장</div>
                  <div class="chat-room-preview">천 조원 잘 되어가나요?</div>
                </li>
                <li class="chat-room-item">
                  <div class="chat-room-name">최윤정</div>
                  <div class="chat-room-preview">지금 회의 들어갑니다</div>
                </li>
                <li class="chat-room-item">
                  <div class="chat-room-name">김지민</div>
                  <div class="chat-room-preview">자료 정리해드릴게요</div>
                </li>
              </ul>
            </div>

            <!-- 채팅방 내용 -->
            <div class="chat-main">
              <div class="chat-header">
                <h3>차팀장</h3>
              </div>
              <div class="chat-messages">
                <div class="message received">
                  <p class="message-text">천 조원 잘 되어가나요?</p>
                  <span class="message-time">8:00 PM</span>
                </div>
                <div class="message received">
                  <p class="message-text">너 나약하지 않잖아</p>
                  <span class="message-time">8:00 PM</span>
                </div>
                <div class="message sent">
                  <p class="message-text">차팀장 님 도저히 못 하겠어요</p>
                  <span class="message-time">8:01 PM</span>
                </div>
                <div class="message sent">
                  <p class="message-text">제발 그만</p>
                  <span class="message-time">8:01 PM</span>
                </div>
              </div>
              <div class="chat-input">
                <input type="text" placeholder="메시지를 입력하세요">
                <button>전송</button>
              </div>
            </div>

          </div>

        </div>
      </main>

    </div>
  </div>

  <footer>&copy; 2025 뜨락상회</footer>
</div>
</body>
</html>
