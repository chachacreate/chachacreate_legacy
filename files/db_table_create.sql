-- (주의)현재 사용자의 테이블을 모두 지우는 명령어
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- 1. 회원
CREATE TABLE member (
    member_id    NUMBER PRIMARY KEY,
    member_email VARCHAR2(255) UNIQUE NOT NULL,
    member_name  VARCHAR2(100) NOT NULL,
    member_pwd   VARCHAR2(255) NOT NULL,
    member_phone VARCHAR2(20) NOT NULL,
    member_regi  VARCHAR2(20),
    join_date  DATE NOT NULL
);

-- 2. 상위카테고리
CREATE TABLE u_category (
    u_category_id   NUMBER PRIMARY KEY,
    u_category_name VARCHAR2(50) NOT NULL
);

-- 3. 하위카테고리
CREATE TABLE d_category (
    d_category_id   NUMBER PRIMARY KEY,
    u_category_id   NUMBER NOT NULL,
    d_category_name VARCHAR2(100) NOT NULL,
    CONSTRAINT fk_d_u_category FOREIGN KEY ( u_category_id )
        REFERENCES u_category ( u_category_id )
);

-- 4. 카테고리(수공예 종류)
CREATE TABLE type_category (
    type_category_id   NUMBER PRIMARY KEY,
    type_category_name VARCHAR2(100)
);

-- 6. 판매자
CREATE TABLE seller (
    seller_id    NUMBER PRIMARY KEY,
    member_id      NUMBER NOT NULL,
    opening_date DATE NOT NULL,
    account      VARCHAR2(50) NOT NULL,
    account_bank VARCHAR2(50) NOT NULL,
    profile_info VARCHAR2(1000),
    personal_check NUMBER(1) DEFAULT 0 NOT NULL CHECK ( personal_check IN ( 0, 1 ) ),
    CONSTRAINT fk_seller_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id )
);

-- 5. 스토어
CREATE TABLE store (
    store_id     NUMBER PRIMARY KEY,
    seller_id    NUMBER NOT NULL,
    logo_img     VARCHAR2(500),
    store_name   VARCHAR2(200),
    store_detail VARCHAR2(400),
    store_url    VARCHAR2(100) UNIQUE,
    sale_cnt    NUMBER DEFAULT 0,
    view_cnt     NUMBER DEFAULT 0,
    CONSTRAINT fk_store_member FOREIGN KEY ( seller_id )
        REFERENCES seller ( seller_id )
);


-- 7. 상품
CREATE TABLE product (
    product_id       NUMBER PRIMARY KEY,
    store_id         NUMBER NOT NULL,
    type_category_id NUMBER NOT NULL,
    d_category_id    NUMBER NOT NULL,
    product_name     VARCHAR2(200) NOT NULL,
    price            NUMBER NOT NULL,
    product_detail   CLOB,
    stock            NUMBER DEFAULT 0,
    product_date     DATE NOT NULL,
    last_modified_date Date,
    sale_cnt        NUMBER DEFAULT 0,
    view_cnt         NUMBER DEFAULT 0,
    flagship_check NUMBER(1) DEFAULT 0 NOT NULL CHECK ( flagship_check IN ( 0, 1 ) ),
    delete_check NUMBER(1) DEFAULT 0 NOT NULL CHECK ( delete_check IN ( 0, 1 ) ),
    CONSTRAINT fk_prod_store FOREIGN KEY ( store_id )
        REFERENCES store ( store_id ),
    CONSTRAINT fk_prod_type_cat FOREIGN KEY ( type_category_id )
        REFERENCES type_category ( type_category_id ),
    CONSTRAINT fk_prod_d_cat FOREIGN KEY ( d_category_id )
        REFERENCES d_category ( d_category_id )
);

-- 8. 상품이미지
CREATE TABLE p_img (
    p_img_id   NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    p_img_url  VARCHAR2(500) NOT NULL,
    p_img_enum VARCHAR2(20) NOT NULL CHECK ( p_img_enum IN ( 'THUMBNAIL', 'DESCRIPTION' ) ),
    p_img_seq  NUMBER NOT NULL,
    CONSTRAINT fk_img_product FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
);

-- 14. 주소
CREATE TABLE addr (
    address_id     NUMBER PRIMARY KEY,
    member_id        NUMBER NOT NULL,
    post_num       VARCHAR2(20) NOT NULL,
    address_road   VARCHAR2(500) NOT NULL,
    address_detail VARCHAR2(500) NOT NULL,
    address_extra  VARCHAR2(500),
    address_check  NUMBER(1) NOT NULL CHECK ( address_check IN ( 0, 1 ) ),
    CONSTRAINT fk_addr_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id )
);

-- 15. 카드
CREATE TABLE card (
    card_id      NUMBER PRIMARY KEY,
    member_id      NUMBER NOT NULL,
    card_num     VARCHAR2(50) NOT NULL,
    card_company VARCHAR2(100) NOT NULL,
    card_token   VARCHAR2(255) NOT NULL,
    card_alias   VARCHAR2(100),
    CONSTRAINT fk_card_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id )
);

-- 16. 장바구니
CREATE TABLE cart (
    cart_id     NUMBER PRIMARY KEY,
    member_id     NUMBER NOT NULL,
    product_id  NUMBER NOT NULL,
    product_cnt NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT fk_cart_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id ),
    CONSTRAINT fk_cart_product FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
);

-- 9. 주문
CREATE TABLE order_info (
    order_id     NUMBER PRIMARY KEY,
    member_id      NUMBER NOT NULL,
    order_date   DATE NOT NULL,
    order_name   VARCHAR2(100) NOT NULL,
    order_phone  VARCHAR2(20) NOT NULL,
    address_id   NUMBER NOT NULL,
    card_id      NUMBER,
    order_status VARCHAR2(30) DEFAULT 'ORDER_OK' NOT NULL CHECK ( order_status IN ( 'ORDER_OK', 'CONFIRM', 'REFUND', 'REFUND_OK' ) ),
    CONSTRAINT fk_ord_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id ),
    CONSTRAINT fk_ord_addr FOREIGN KEY ( address_id )
        REFERENCES addr ( address_id ),
    CONSTRAINT fk_ord_card FOREIGN KEY ( card_id )
        REFERENCES card ( card_id )
);

-- 10. 주문상세
CREATE TABLE order_detail (
    order_detail_id NUMBER PRIMARY KEY,
    order_id        NUMBER NOT NULL,
    product_id      NUMBER NOT NULL,
    order_cnt          NUMBER NOT NULL,
    order_price        NUMBER NOT NULL,
    CONSTRAINT fk_od_order FOREIGN KEY ( order_id )
        REFERENCES order_info ( order_id ),
    CONSTRAINT fk_od_prod FOREIGN KEY ( product_id )
        REFERENCES product ( product_id )
);

-- 11. 배송
CREATE TABLE delivery (
    delivery_id       NUMBER PRIMARY KEY,
    order_id          NUMBER NOT NULL,
    delivery_check    NUMBER(1) DEFAULT 0 NOT NULL CHECK ( delivery_check IN ( 0, 1, 2) ),
    delivery_date     DATE,
    delivery_fin_date DATE,
    CONSTRAINT fk_delivery_order FOREIGN KEY ( order_id )
        REFERENCES order_info ( order_id )
);

-- 12. 리뷰
CREATE TABLE review (
    review_id       NUMBER PRIMARY KEY,
    order_detail_id NUMBER NOT NULL,
    review_date     DATE NOT NULL,
    review_text     CLOB NOT NULL,
    CONSTRAINT fk_review_od FOREIGN KEY ( order_detail_id )
        REFERENCES order_detail ( order_detail_id )
);

-- 13. 건의사항
CREATE TABLE question (
    question_id    NUMBER PRIMARY KEY,
    member_id        NUMBER NOT NULL,
    question_date  DATE NOT NULL,
    question_title VARCHAR2(200) NOT NULL,
    question_text  CLOB NOT NULL,
    CONSTRAINT fk_q_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id )
);


-- 17. 채팅방
CREATE TABLE chatroom (
    chatroom_id NUMBER PRIMARY KEY,
    store_id    NUMBER NOT NULL,
    member_id     NUMBER NOT NULL,
    CONSTRAINT fk_chat_store FOREIGN KEY ( store_id )
        REFERENCES store ( store_id ),
    CONSTRAINT fk_chat_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id )
);

-- 18. 채팅
CREATE TABLE chatting (
    chatting_id   NUMBER PRIMARY KEY,
    chatroom_id   NUMBER NOT NULL,
    chatting_text VARCHAR2(1000) NOT NULL,
    chatting_date DATE NOT NULL,
    member_check NUMBER(1) NOT NULL CHECK ( member_check IN ( 0, 1 ) ),
    CONSTRAINT fk_chatting_room FOREIGN KEY ( chatroom_id )
        REFERENCES chatroom ( chatroom_id )
);

-- 19. 신고
CREATE TABLE report (
    report_id    NUMBER PRIMARY KEY,
    member_id      NUMBER NOT NULL,
    seller_id    NUMBER NOT NULL,
    report_date  DATE NOT NULL,
    report_title VARCHAR2(200) NOT NULL,
    report_text  CLOB NOT NULL,
    member_check NUMBER(1) NOT NULL CHECK ( member_check IN ( 0, 1 ) ),
    CONSTRAINT fk_report_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id ),
    CONSTRAINT fk_report_seller FOREIGN KEY ( seller_id )
        REFERENCES seller ( seller_id )
);

-- 20. 공지사항
CREATE TABLE notice (
    notice_id    NUMBER PRIMARY KEY,
    store_id     NUMBER NOT NULL,
    notice_check NUMBER(1) NOT NULL,
    notice_title VARCHAR2(200) NOT NULL,
    notice_text  CLOB NOT NULL,
    notice_date  DATE NOT NULL,
    CONSTRAINT fk_notice_store FOREIGN KEY ( store_id )
        REFERENCES store ( store_id )
);

-- 21. 알림 메시지
CREATE TABLE alter_message(
    alter_message_id NUMBER PRIMARY KEY,
    member_id NUMBER NOT NULL,
    message_title VARCHAR2(100),
    message_content VARCHAR2(255),
    CONSTRAINT fk_alter_message_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id )
);

-- 22. 이메일 인증 키
CREATE TABLE "AUTH_KEY" (
   "AUTH_KEY_NO"   NUMBER      NOT NULL PRIMARY KEY,
   "CODE"   CHAR(6)      NOT NULL,
   "EMAIL"   VARCHAR2(50)      NOT NULL,
   "CREATE_TIME"   DATE   DEFAULT SYSDATE   NOT NULL
);

COMMENT ON COLUMN "AUTH_KEY"."AUTH_KEY_NO" IS '인증키 구분 번호(SEQ_AUTH_KEY_NO)';

COMMENT ON COLUMN "AUTH_KEY"."CODE" IS '코드';

COMMENT ON COLUMN "AUTH_KEY"."EMAIL" IS '이메일';

COMMENT ON COLUMN "AUTH_KEY"."CREATE_TIME" IS '인증 코드 생성 시간';

-- 프로시저+JOB
-- 결제 7일 후 결제완료 
CREATE OR REPLACE PROCEDURE UPDATE_ORDER_STATUS IS
BEGIN
    UPDATE ORDER_INFO
    SET ORDER_STATUS = 'CONFIRM'
    WHERE ORDER_STATUS = 'ORDER_OK'
      AND ORDER_DATE <= SYSDATE - 7;

    COMMIT;
END;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'JOB_UPDATE_ORDER_STATUS',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'UPDATE_ORDER_STATUS',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0',
    enabled         => TRUE
  );
END;
/

-- (주의) 현재 사용자의 모든 시퀀스를 drop하는 명령어
BEGIN
  FOR seq IN (SELECT sequence_name FROM user_sequences) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE "' || seq.sequence_name || '"';
  END LOOP;
END;
/

-- 회원 시퀀스 
CREATE SEQUENCE seq_member_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 스토어
CREATE SEQUENCE seq_store_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 판매자
CREATE SEQUENCE seq_seller_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 상품
CREATE SEQUENCE seq_product_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 상품이미지
CREATE SEQUENCE seq_p_img_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 주문
CREATE SEQUENCE seq_order_info_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 주문상세
CREATE SEQUENCE seq_order_detail_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 배송
CREATE SEQUENCE seq_delivery_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 리뷰
CREATE SEQUENCE seq_review_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 건의사항
CREATE SEQUENCE seq_question_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 주소
CREATE SEQUENCE seq_address_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 카드
CREATE SEQUENCE seq_card_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 장바구니
CREATE SEQUENCE seq_cart_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 채팅방
CREATE SEQUENCE seq_chatroom_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 채팅
CREATE SEQUENCE seq_chatting_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 신고
CREATE SEQUENCE seq_report_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 공지사항
CREATE SEQUENCE seq_notice_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 수공예 종류 카테고리 시퀀스 생성
CREATE SEQUENCE seq_type_category_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 하위카테고리 시퀀스 생성
CREATE SEQUENCE seq_d_category_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 상위카테고리 시퀀스 생성
CREATE SEQUENCE seq_u_category_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 알림 메시지 시퀀스 생성
CREATE SEQUENCE seq_alter_message_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 이메일 인증 시퀀스 생성
CREATE SEQUENCE SEQ_AUTH_KEY_NO
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 카테고리 값 insert
insert into type_category VALUES(seq_type_category_id.nextval, '뜨개질');
insert into type_category VALUES(seq_type_category_id.nextval, '금속공예');
insert into type_category VALUES(seq_type_category_id.nextval, '목공예');
insert into type_category VALUES(seq_type_category_id.nextval, '도자기공예');
insert into type_category VALUES(seq_type_category_id.nextval, '유리공예');
insert into type_category VALUES(seq_type_category_id.nextval, '가죽공예');
insert into type_category VALUES(seq_type_category_id.nextval, '레진공예');
insert into type_category VALUES(seq_type_category_id.nextval, '식물공예');
insert into type_category VALUES(seq_type_category_id.nextval, '양재공예');
insert into type_category VALUES(seq_type_category_id.nextval, '기타');

-- 상위 카테고리 값
insert into U_CATEGORY VALUES(seq_d_category_id.nextval, '패션잡화');
insert into U_CATEGORY VALUES(seq_d_category_id.nextval, '인테리어 소품');
insert into U_CATEGORY VALUES(seq_d_category_id.nextval, '악세서리');
insert into U_CATEGORY VALUES(seq_d_category_id.nextval, '생활잡화');
insert into U_CATEGORY VALUES(seq_d_category_id.nextval, '기타');

-- 하위 카테고리 값
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 1,'상의');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 1,'하의');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 1,'가방');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 1,'지갑');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 1,'기타(목도리, 모자, 벨트, etc)');

insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 2,'디퓨저,캔들');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 2,'무드등');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 2,'꽃,식물');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 2,'가구');

insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 3,'반지');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 3,'팔찌');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 3,'목걸이');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 3,'키링');

insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 4,'비누');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 4,'그릇');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 4,'식기류');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 4,'컵');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 4,'케이스');

insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 5,'향수');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 5,'인형');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 5,'반려동물');
insert into D_CATEGORY VALUES(seq_u_category_id.nextval, 5,'문구');

select * from d_category;

-- db 테스트용 user 추가
insert into member (
    member_id,
    member_email,
    member_name,
    member_pwd,
    member_phone,
    member_regi,
    join_date
) VALUES (
    seq_member_id.NEXTVAL,
    'testuser@example.com',
    '테스트회원',
    'password123',
    '010-1234-5678',
    '서울시 강남구',
    SYSDATE
);
