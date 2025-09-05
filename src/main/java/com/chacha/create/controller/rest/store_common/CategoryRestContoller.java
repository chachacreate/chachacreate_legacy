package com.chacha.create.controller.rest.store_common;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.enums.category.DCategoryEnum;
import com.chacha.create.common.enums.category.TypeCategoryEnum;
import com.chacha.create.common.enums.category.UCategoryEnum;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/legacy")
public class CategoryRestContoller {
	@GetMapping("/category")
	public Map<String, Object> showProductInsertForm(Model model) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeCategories", TypeCategoryEnum.values());
		map.put("uCategories", UCategoryEnum.values());

	    // ✅ dCategory를 uCategory 기준으로 그룹핑해서 Map에 담기
	    Map<Integer, List<Map<String, Object>>> dCategoriesByU = Arrays.stream(DCategoryEnum.values())
	    	    .collect(Collectors.groupingBy(
	    	        d -> d.getUcategory().getId(),  // key: uCategoryId
	    	        Collectors.mapping(d -> {
	    	            Map<String, Object> map2 = new HashMap<>();
	    	            map2.put("id", d.getId());
	    	            map2.put("name", d.getName());
	    	            return map2;
	    	        }, Collectors.toList())
	    	    ));

	    map.put("dCategoriesByU", dCategoriesByU); // ✅ Map<Integer, List<id-name>> 형태

	    return map;
	}
}
