package com.chacha.create.controller.rest.mainhome.personal;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.PersonalProductDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.mainhome.personal.PersonalProductService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/main/sell")
@Slf4j
public class PersonalProductRestController {

	@Autowired
	private PersonalProductService personalProductService;

	@PostMapping(value = "/sellregister", consumes = "application/json", produces = "application/json")
	public ResponseEntity<ApiResponse<Integer>> registerProduct(@RequestBody PersonalProductDTO dto,
			HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");

		log.info("로그인된 member: {}", loginMember);
		int result = personalProductService.insertMainProductWithImages(dto, loginMember);

		if (result > 0) {
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.CREATED, result));
		} else {
			return ResponseEntity.status(ResponseCode.FAIL.getStatus()).body(new ApiResponse<>(ResponseCode.FAIL, 0));
		}
	}

	@GetMapping(value = "/products", produces = "application/json")
	public ResponseEntity<ApiResponse<List<PersonalProductDTO>>> getProductsBySeller(HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");

		log.info("로그인된 member: {}", loginMember);
		List<PersonalProductDTO> products = personalProductService.getProductsByMemberId(loginMember);

		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, products));
	}

	@PutMapping(value = "/sellregister/update", consumes = "application/json", produces = "application/json")
	public ResponseEntity<ApiResponse<Integer>> updateProduct(@RequestBody PersonalProductDTO dto,
			HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		log.info("로그인된 member: {}", loginMember);
		int result = personalProductService.updateMainProductWithImages(dto, loginMember);

		if (result > 0) {
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
		} else {
			return ResponseEntity.status(ResponseCode.FAIL.getStatus()).body(new ApiResponse<>(ResponseCode.FAIL, 0));
		}
	}

	@PutMapping(value = "/sellregister/delete", consumes = "application/json", produces = "application/json")
	public ResponseEntity<ApiResponse<Integer>> deleteProduct(@RequestBody Map<String, Integer> param,
			HttpSession session) {
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		int productId = param.get("productId");

		log.info("로그인된 memberId: {}, 삭제 요청 productId: {}", loginMember, productId);

		int result = personalProductService.deleteMainProduct(productId, loginMember);

		if (result > 0) {
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, result));
		} else {
			return ResponseEntity.status(ResponseCode.FAIL.getStatus()).body(new ApiResponse<>(ResponseCode.FAIL, 0));
		}
	}
	
	@GetMapping("/category")
	public ResponseEntity<ApiResponse<Map<String, Object>>> categoryMap(){
		return ResponseEntity.ok(new ApiResponse<Map<String, Object>>(ResponseCode.OK, personalProductService.categoryList()));
	}
}
