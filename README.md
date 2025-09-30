chachacreate_legacy

📌 소개
chachacreate_legacy는 JSP + Spring(서블릿 기반) + Oracle로 구현된 1차 레거시 백엔드/서버사이드 렌더링 프로젝트입니다.
수공예 커뮤니티/커머스의 초기 버전으로, 2차(Spring Boot + React)로의 전환 전 핵심 도메인 흐름을 담당합니다. DB 스키마/업무 플로우는 2차로 이관 가능한 형태로 설계되었습니다.

🚀 주요 기능

🔑 회원가입/로그인(이메일 인증/OTP) 및 기본 세션 인증

🏪 판매자/스토어 등록 및 관리(프로필, 스토어 소개, 로고)

🛍️ 상품 CRUD, 이미지(썸네일/설명) 관리, 카테고리(상/하위) 조회

🧺 장바구니, 주문/주문상세, 배송 상태 관리(일부 스케줄러 처리)

✍️ 리뷰/공지/문의(건의사항), 채팅방/메시지

📊 간단 통계(판매 수/조회 수) 및 정산 사전 구조

🧭 URL 구조/REST 스타일 API는 2차 전환을 고려하여 정의됨

🛠 기술 스택

View: JSP / JSTL

Server: Apache Tomcat (WAR 배포)

Lang/Framework: Java 8+, Spring MVC (XML/Annotation 혼용 가능)

DB: Oracle (PL/SQL, Scheduler Job)

Build: Maven or Gradle (팀 표준에 맞춰 선택)

Auth: 세션 기반(이메일 인증 테이블/프로시저 포함)

📂 폴더 구조(예시)
chachacreate_legacy/
├─ src/main/java/
│  └─ com/chacha/legacy/
│     ├─ config/                 # Spring 설정, DataSource, MyBatis/JDBC 등
│     ├─ common/                 # 공통 유틸/예외/인터셉터
│     ├─ domains/
│     │  ├─ member/              # 회원(컨트롤러/서비스/DAO/VO)
│     │  ├─ seller/              # 판매자/스토어
│     │  ├─ product/             # 상품/이미지/카테고리
│     │  ├─ order/               # 주문/주문상세/배송
│     │  ├─ review/              # 리뷰
│     │  ├─ board/               # 공지/문의
│     │  └─ chat/                # 채팅/채팅방
│     └─ admin/                  # 관리자
├─ src/main/webapp/
│  ├─ WEB-INF/
│  │  ├─ views/                  # JSP 뷰
│  │  └─ web.xml
│  ├─ resources/                 # 정적 리소스(css/js/img)
│  └─ index.jsp
├─ src/main/resources/
│  ├─ sql/                       # 초기 스키마/시드
│  └─ application.properties     # (또는 XML), 환경설정
├─ pom.xml (또는 build.gradle)
└─ README.md


도메인/패키징은 2차 코드컨벤션의 도메인 중심 구조 원칙을 유지하여 이관/병행을 쉽게 합니다.

⚙️ 실행 방법
1) DB 준비(Oracle)

Oracle 유저/schema 생성 후 접속

초기 스키마/데이터 생성
src/main/resources/sql/regacydb.sql를 실행합니다. (테이블 드롭 → 전 테이블 생성, FK/체크 제약, 프로시저/잡 포함)

(선택) 테스트 데이터 시드 추가

2) 데이터소스 설정

JNDI(Tomcat) 권장: context.xml/server.xml에 Oracle DataSource 등록 후 web.xml 또는 Spring 설정에서 lookup

또는 JDBC 직접 연결: application.properties(또는 XML)에서 spring.datasource.* 지정

3) 빌드 & 배포

Maven

mvn clean package


target/*.war를 Tomcat webapps/에 배포

Gradle

./gradlew clean build


build/libs/*.war 배포

4) 접속

로컬 Tomcat 포트 기준:

http://localhost:8080/


주요 진입 경로는 스토어/메인/마이페이지/관리자 메뉴로 구성됩니다. (2차 API와 라우팅 정합성 유지)

📑 데이터베이스(핵심 테이블)

회원/주소/카드: member, addr, card

판매자/스토어: seller, store

상품/이미지/카테고리: product, p_img, u_category, d_category, type_category

주문/상세/배송: order_info, order_detail, delivery

리뷰/공지/문의: review, notice, question

채팅: chatroom, chatting

이메일 인증키: AUTH_KEY (회원가입/비밀번호 찾기 등)

스케줄러: UPDATE_ORDER_STATUS 프로시저 + JOB_UPDATE_ORDER_STATUS (주문 7일 후 확정 처리 예시)

2차(신규) MySQL ERD와 1차(레거시) Oracle 스키마가 유사 도메인 개념을 공유하여 마이그레이션/동시 운영을 고려했습니다.

🔌 API 개요(레거시 기준)

메인/회원/인증: 회원가입(이메일/OTP), 로그인, 비밀번호 재설정

스토어/상품/클래스: 목록/상세/검색/정렬, 장바구니/주문/결제 연동 준비

구매자 마이페이지: 주문/리뷰/문의/채팅

판매자: 상품/클래스/정산/주문상태/공지/메시지

관리자: 스토어/회원/클래스/신고/정산 관리

2차 전환을 위한 경로/쿼리파라미터 규칙(복수형/kebab-case, Path=식별, Query=옵션)을 맞추어 문서화함.

✅ 코드 컨벤션

백엔드(레거시 Java/Spring)

도메인 중심 패키징(Controller/Service/DAO/VO를 같은 기능 하위에 배치)

DTO/엔티티/VO/Enum 네이밍 및 검증/직렬화 분리(요청 DTO vs 응답 DTO)

REST 네이밍: 복수형·kebab-case, Path=식별자, Query=필터/페이지/정렬

시간/로그/인코딩: UTC, @Slf4j, UTF-8

(2차 기준 컨벤션을 1차에도 최대한 준수하여 이관 비용 최소화)

프런트 연동 관점

레거시 JSP 뷰와 병행 시에도 외부 소비용 REST 응답을 표준화(2차 FE에서 재사용)

요청/응답 DTO 분리로 오버포스팅/민감정보 노출 방지

📌 추가 예정

관리자 UI/UX JSP 개선(검색/정렬/페이징 일관화)

접근성(Barrier-free) 개선(라벨/대체텍스트/키보드 네비게이션)

SEO 대응(SSR 메타/스키마 태그 정리)

2차(Boot+React)와 ERD/API 동기화 자동화 스크립트 정리

👥 팀 소개

차민건: PM, 로그인/채팅 구현, 배포/운영

천희찬: 주문 상태 처리, 판매 통계 그래프

안세현: 정산/매출, 클래스 예약/통계

김지민: 반응형 디자인, 페이지/라우팅

최윤정: 가격추천 AI, 상품/클래스 CRUD

이재희: DB/S3 배포/운영, 결제/주문

부록

레거시 DB 스키마: regacydb.sql (Oracle)

2차(참고) ERD: 신규 MySQL 구조(이관 대비)

2차(참고) API 명세: REST 경로/파라미터 일관화 참고

코드 컨벤션(공통): 도메인 중심 구조/DTO 분리/REST 규칙
