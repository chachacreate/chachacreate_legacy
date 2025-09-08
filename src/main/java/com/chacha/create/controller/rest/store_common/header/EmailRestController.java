package com.chacha.create.controller.rest.store_common.header;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.chacha.create.service.store_common.header.auth.EmailService;

@RestController
@RequestMapping("/legacy/auth/join")
@SessionAttributes("authKey")
public class EmailRestController {
    
    @Autowired
    private EmailService service;
    
    @GetMapping("/email")
    public int signUp(String email) {
        return service.signUp(email, "회원 가입");
    }
    
    
    @GetMapping("/otp")
    public int checkAuthKey(@RequestParam Map<String, Object> paramMap){

       System.out.println(paramMap); // {inputKey=wc3rxG, email=knbdh@nate.com}
        
        return service.checkAuthKey(paramMap);
    }
    
}