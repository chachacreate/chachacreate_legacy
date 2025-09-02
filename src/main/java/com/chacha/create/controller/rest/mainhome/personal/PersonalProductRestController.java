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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.product.PersonalProductDTO;
import com.chacha.create.common.entity.member.MemberEntity;
import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.mainhome.personal.PersonalProductService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/legacy/main/sell")
@Slf4j
public class PersonalProductRestController {

	@Autowired
	private PersonalProductService personalProductService;
	
	/**
	 * 새로운 multipart/form-data API - S3 이미지 업로드
	 */
	@PostMapping(value = "/sellregister", consumes = "multipart/form-data", produces = "application/json")
	public ResponseEntity<ApiResponse<Integer>> registerProductWithFiles(
			@RequestParam("productName") String productName,
			@RequestParam("productDesc") String productDesc,
			@RequestParam("productPrice") int productPrice,
			@RequestParam("stock") int stock,
			@RequestParam("typeCategoryId") String typeCategoryId,
			@RequestParam("ucategoryId") String ucategoryId,
			@RequestParam("dcategoryId") String dcategoryId,
			@RequestParam(value = "image1", required = false) MultipartFile image1,
			@RequestParam(value = "image2", required = false) MultipartFile image2,
			@RequestParam(value = "image3", required = false) MultipartFile image3,
			HttpSession session) {
		
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		log.info("로그인된 member: {}", loginMember);

		// DTO 생성
		PersonalProductDTO dto = PersonalProductDTO.builder()
				.productName(productName)
				.productDetail(productDesc)
				.price(productPrice)
				.stock(stock)
				.typeCategoryId(TypeCategoryEnum.valueOf(typeCategoryId))
				.ucategoryId(UCategoryEnum.valueOf(ucategoryId))
				.dcategoryId(DCategoryEnum.valueOf(dcategoryId))
				.build();

		int result = personalProductService.insertMainProductWithImages(dto, loginMember, image1, image2, image3);

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
		log.info(products.toString());

		return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, products));
	}
	
	/**
	 * 새로운 multipart/form-data API - S3 이미지 업로드
	 */
	@PostMapping(value = "/sellregister/update", consumes = "multipart/form-data", produces = "application/json")
	public ResponseEntity<ApiResponse<Integer>> updateProductWithFiles(
			@RequestParam("productId") int productId,
			@RequestParam("productName") String productName,
			@RequestParam("productDesc") String productDesc,
			@RequestParam("productPrice") int productPrice,
			@RequestParam("stock") int stock,
			@RequestParam("typeCategoryId") String typeCategoryId,
			@RequestParam("ucategoryId") String ucategoryId,
			@RequestParam("dcategoryId") String dcategoryId,
			@RequestParam(value = "image1", required = false) MultipartFile image1,
			@RequestParam(value = "image2", required = false) MultipartFile image2,
			@RequestParam(value = "image3", required = false) MultipartFile image3,
			HttpSession session) {
		
		MemberEntity loginMember = (MemberEntity) session.getAttribute("loginMember");
		log.info("로그인된 member: {}, 수정할 productId: {}", loginMember, productId);

		// DTO 생성
		PersonalProductDTO dto = PersonalProductDTO.builder()
				.productId(productId)
				.productName(productName)
				.productDetail(productDesc)
				.price(productPrice)
				.stock(stock)
				.typeCategoryId(TypeCategoryEnum.valueOf(typeCategoryId))
				.ucategoryId(UCategoryEnum.valueOf(ucategoryId))
				.dcategoryId(DCategoryEnum.valueOf(dcategoryId))
				.build();

		int result = personalProductService.updateMainProductWithImages(dto, loginMember, image1, image2, image3);

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
			return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, "상품이 성공적으로 삭제되었습니다.", result));
		} else if (result == -2) {
			return ResponseEntity.status(ResponseCode.FORBIDDEN.getStatus())
					.body(new ApiResponse<>(ResponseCode.FORBIDDEN, "삭제 권한이 없습니다.", 0));
		} else {
			return ResponseEntity.status(ResponseCode.FAIL.getStatus())
					.body(new ApiResponse<>(ResponseCode.FAIL, "상품 삭제에 실패했습니다.", 0));
		}
	}
	
	@GetMapping("/category")
	public ResponseEntity<ApiResponse<Map<String, Object>>> categoryMap(){
		return ResponseEntity.ok(new ApiResponse<Map<String, Object>>(ResponseCode.OK, personalProductService.categoryList()));
	}
}