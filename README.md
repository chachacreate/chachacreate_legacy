# chachacreate_legacy

📌 **소개**  
`chachacreate_legacy`는 **JSP + Spring MVC + MyBatis + Oracle** 기반의 1차 레거시 프로젝트입니다.  
서버사이드 렌더링(SSR)과 레거시 API를 담당하며, 2차(Spring Boot + React) 전환을 고려해 **표준 JSON 응답 스키마**와 **경로 규칙**을 공유합니다.

---

## 🚀 주요 기능
- 🔑 회원가입/로그인(세션 기반), 이메일 인증/OTP
- 🏪 판매자/스토어 등록 및 관리(프로필, 스토어 소개, 로고)
- 🛍️ 상품 CRUD, 이미지 관리(썸네일/상세), 카테고리(대/중/타입)
- 🧺 장바구니, 주문/주문상세, 배송/상태 변경(스케줄러 포함)
- ✍️ 리뷰/공지/문의, 채팅(웹소켓)
- 📊 간단 통계/정산 사전 구조
- 🔌 2차 전환을 고려한 **REST 스타일 API(JSON)** 병행 제공

---

## 🛠 기술 스택
- **JDK**: Java 11  
- **Framework**: Spring MVC (+ Spring WebSocket), MyBatis  
- **View**: JSP, JSTL  
- **DB**: Oracle (PL/SQL, Scheduler)  
- **Build**: Maven  
- **Infra**: Apache Tomcat (WAR 배포)  
- **Etc.**: AWS S3 업로드 유틸, 공통 예외/응답 래퍼

---

## 📂 폴더 구조 (현재 프로젝트 기준)

```
src/main/java/com/chacha/create/
├─ common
│  ├─ dto/            # 공통 DTO (요청/응답/페이지네이션 등)
│  ├─ entity/         # VO/엔티티(레거시용)
│  ├─ enums/          # 공통 Enum (응답코드, 주문상태 등)
│  ├─ exception/      # 공통 예외 타입
│  ├─ mapper/         # MyBatis 매퍼 인터페이스
│  └─ typehandler/    # MyBatis TypeHandler
│
├─ controller
│  ├─ controller/     # JSP 렌더링 컨트롤러
│  ├─ rest/           # JSON 응답 REST 컨트롤러 (/legacy/**)
│  └─ websocket/      # STOMP/WebSocket 엔드포인트
│
├─ service
│  ├─ buyer/          # 구매자 영역 서비스
│  ├─ mainhome/       # 메인/홈 서비스
│  ├─ manager/        # 관리자 서비스
│  ├─ seller/         # 판매자 영역 서비스
│  └─ store_common/   # 스토어 공통(테마/커스터마이징 등)
│
└─ util               # 유틸리티/설정/인프라 (아래 모두 포함)
   ├─ exception/          # 전역 예외처리(@ControllerAdvice)
   ├─ Filter/             # 인증/로깅 등 서블릿 필터
   ├─ s3/                 # S3Uploader 등 파일 업로드 유틸
   ├─ BootAPIUtil.java    # 2차(Spring Boot) API 호출 유틸
   ├─ BootPathConfig.java # 부트 API 경로/게이트웨이 설정
   ├─ DataSourceConfig.java # DataSource/MyBatis 설정
   └─ ServiceUtil.java    # 서비스 공통 유틸
```
```
src/main/resources/
├─ mybatis/mapper/    # XML 매퍼
├─ mybatis/mybatis-config.xml
├─ application.properties (또는 XML 설정)
└─ sql/regacydb.sql   # 초기 스키마/시드/프로시저/잡
```

> 레거시/신규의 **도메인 중심 구조**와 **응답 래퍼 일관성**을 유지해 이관 비용을 최소화합니다.

---

## ⚙️ 실행 방법

### 1) DB 준비(Oracle)
1. Oracle 사용자/스키마 생성 후 접속
2. `src/main/resources/sql/regacydb.sql` 실행  
   - 테이블/제약/시드/프로시저(`UPDATE_ORDER_STATUS`) & 잡(`JOB_UPDATE_ORDER_STATUS`) 포함
3. (선택) 개발용 샘플 데이터 추가

### 2) 데이터소스 & MyBatis 설정
**util/DataSourceConfig.java** 또는 XML 기반으로 설정합니다.

- (권장) **Tomcat JNDI**
  - `${TOMCAT_HOME}/conf/context.xml`
    ```xml
    <Resource name="jdbc/ChachaOracle"
              auth="Container"
              type="javax.sql.DataSource"
              driverClassName="oracle.jdbc.OracleDriver"
              url="jdbc:oracle:thin:@//localhost:1521/ORCLPDB1"
              username="CHACHA" password="***"
              maxTotal="50" maxIdle="10"
              validationQuery="SELECT 1 FROM DUAL"/>
    ```
  - Spring에서 JNDI lookup → `SqlSessionFactory`, `MapperScan` 구성

- (대안) **직접 JDBC**
  - `application.properties`
    ```properties
    spring.datasource.url=jdbc:oracle:thin:@//localhost:1521/ORCLPDB1
    spring.datasource.username=CHACHA
    spring.datasource.password=***
    spring.datasource.driver-class-name=oracle.jdbc.OracleDriver

    mybatis.config-location=classpath:mybatis/mybatis-config.xml
    mybatis.mapper-locations=classpath:mybatis/mapper/*.xml
    ```

### 3) 빌드 & 배포 (Maven)
```bash
mvn clean package
# target/*.war 를 Tomcat webapps/ 에 배포
```

### 4) 접속
```
http://localhost:8080/
```

---

## 🔌 REST API (레거시 JSON, /legacy/**)

> JSP 렌더링과 별개로 **React에서 재사용**할 수 있도록 JSON 응답을 제공합니다.  
> **응답 래퍼**: `{ "status": 200, "message": "OK", "data": { ... } }`

- **상품**
  - `GET    /legacy/{storeUrl}/products`
  - `GET    /legacy/{storeUrl}/products/{productId}`
  - `POST   /legacy/{storeUrl}/seller/products`
  - `PUT    /legacy/{storeUrl}/seller/products/{productId}`
  - `DELETE /legacy/{storeUrl}/seller/products/{productId}`

- **주문**
  - `POST   /legacy/{storeUrl}/orders`
  - `GET    /legacy/{storeUrl}/orders/{orderId}`
  - `PUT    /legacy/{storeUrl}/orders/{orderId}/status`

- **리뷰/공지/문의**
  - `GET    /legacy/{storeUrl}/reviews`
  - `GET    /legacy/{storeUrl}/seller/notices`
  - `POST   /legacy/{storeUrl}/questions`

- **채팅(WebSocket)**
  - 엔드포인트: `/ws/chat/**`
  - STOMP topic 예: `/topic/{storeUrl}/rooms/{roomId}`

---

## 🤝 2차(Boot) 연동
- **util/BootAPIUtil**, **util/BootPathConfig**  
  - 레거시에서 2차(Spring Boot) API를 호출할 때 사용(게이트웨이/호스트/경로 중앙관리)
  - 예: 주문상태/재고/정산 통합 API를 부트로 위임
- **세션↔JWT 브리지**(필요 시): 레거시 세션을 부트 JWT로 변환하여 FE 단일 인증 유지

---

## 🗂 코드 컨벤션(요약)
- **패키징**: 도메인 중심(`controller/service/common`) + 인프라/유틸은 `util/` 집약
- **네이밍**: REST 경로는 복수형·kebab-case / Path=식별자, Query=옵션/필터
- **DTO 분리**: 요청 DTO vs 응답 DTO
- **예외 처리**: `util/exception`의 전역 `@ControllerAdvice` + 표준 응답 래퍼
- **로깅/인코딩/시간대**: `@Slf4j`, UTF-8, 서버 표준 시간대 일관화
- **MyBatis**: `common/mapper` ↔ `resources/mybatis/mapper/*.xml`, `typehandler`로 Enum 매핑
- **WebSocket**: `/ws/chat/**` 엔드포인트와 토픽 네이밍 규칙 통일

---

## 📌 추가 예정
- 관리자 JSP UI/UX 개선(검색/정렬/페이징 공통 컴포넌트화)
- 접근성(Barrier-free) 개선(대체텍스트/라벨/키보드 네비게이션)
- SEO 대응(SSR 메타/OG/구조화 데이터)
- 부트 연동 시나리오별 샘플(주문상태/재고/정산) 코드 템플릿

---

## 👥 팀 소개
- **차민건**: PM, 로그인/채팅 구현, 배포/운영  
- **천희찬**: 주문 상태 처리, 판매 통계 그래프  
- **안세현**: 정산/매출, 클래스 예약/통계  
- **김지민**: 반응형 디자인, 페이지/라우팅  
- **최윤정**: 가격추천 AI, 상품/클래스 CRUD  
- **이재희**: DB/S3 배포/운영, 결제/주문

---

### 부록
- **레거시 DB 스키마**: `src/main/resources/sql/regacydb.sql`  
- **웹소켓 nginx 예시**: `/ws/chat/**` 업그레이드/타임아웃 설정  
- **샘플 오류 가이드**: TooManyResults / Ambiguous mapping / 405 대응 팁
