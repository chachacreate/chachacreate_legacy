package com.chacha.create.service.store_common.header.auth;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chacha.create.common.dto.login.NaverClientDTO;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NaverService {
	
	@Autowired
	NaverClientDTO naverClientDTO;

	public String getAccessTokenFromNaver(String code, String state) {
	    String accessToken = "";
	    String reqUrl = "https://nid.naver.com/oauth2.0/token";

	    try {
	        URL url = new URL(reqUrl);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

	        // 요청 헤더 설정
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
	        conn.setDoOutput(true); // POST 요청을 위한 설정

	        // 요청 바디 작성
	        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
	        StringBuilder sb = new StringBuilder();
	        sb.append("grant_type=authorization_code");
	        sb.append("&client_id=").append(naverClientDTO.getClientId());
	        sb.append("&client_secret=").append(naverClientDTO.getClientSecret());
	        sb.append("&code=").append(code);
	        sb.append("&state=").append(state);

	        bw.write(sb.toString());
	        bw.flush();

	        int responseCode = conn.getResponseCode();
	        log.info("[NaverApi.getAccessToken] responseCode = {}", responseCode);

	        BufferedReader br;
	        if (responseCode >= 200 && responseCode < 300) {
	            br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }

	        String line;
	        StringBuilder responseSb = new StringBuilder();
	        while ((line = br.readLine()) != null) {
	            responseSb.append(line);
	        }

	        String result = responseSb.toString();
	        log.info("responseBody = {}", result);

	        JsonElement element = JsonParser.parseString(result);
	        accessToken = element.getAsJsonObject().get("access_token").getAsString();

	        br.close();
	        bw.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return accessToken;
	}
	
	public HashMap<String, Object> getUserInfoFromNaver(String accessToken) {
	    HashMap<String, Object> userInfo = new HashMap<>();
	    String reqUrl = "https://openapi.naver.com/v1/nid/me";

	    try {
	        URL url = new URL(reqUrl);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

	        int responseCode = conn.getResponseCode();
	        log.info("[NaverApi.getUserInfo] responseCode : {}", responseCode);

	        BufferedReader br;
	        if (responseCode >= 200 && responseCode < 300) {
	            br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }

	        String line;
	        StringBuilder responseSb = new StringBuilder();
	        while ((line = br.readLine()) != null) {
	            responseSb.append(line);
	        }

	        String result = responseSb.toString();
	        log.info("responseBody = {}", result);

	        JsonElement element = JsonParser.parseString(result);
	        JsonObject responseObj = element.getAsJsonObject().getAsJsonObject("response");

	        // 선택한 정보만 추출
	        String id = responseObj.get("id").getAsString();
	        String name = responseObj.has("name") ? responseObj.get("name").getAsString() : null;
	        String email = responseObj.has("email") ? responseObj.get("email").getAsString() : null;
	        String gender = responseObj.has("gender") ? responseObj.get("gender").getAsString() : null;
	        String birthday = responseObj.has("birthday") ? responseObj.get("birthday").getAsString() : null;
	        String birthyear = responseObj.has("birthyear") ? responseObj.get("birthyear").getAsString() : null;
	        String mobile = responseObj.has("mobile") ? responseObj.get("mobile").getAsString() : null;

	        // 로그 출력
	        log.info("네이버 ID: {}", id);
	        log.info("이름: {}", name);
	        log.info("이메일: {}", email);
	        log.info("출생연도: {}", birthyear);
	        log.info("출생일: {}", birthday);
	        log.info("성별: {}", gender);
	        log.info("휴대전화번호: {}", mobile);

	        // Map에 저장
	        userInfo.put("name", name);
	        userInfo.put("email", email);
	        userInfo.put("birthyear", birthyear);
	        userInfo.put("birthday", birthday);
	        userInfo.put("gender", gender);
	        userInfo.put("mobile", mobile);

	        br.close();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return userInfo;
	}


}
