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
        Map<String, Object> map = new HashMap<>();

        // ✅ id/name 배열로 내려주기
        map.put("typeCategories",
            Arrays.stream(TypeCategoryEnum.values())
                .map(t -> Map.of("id", t.getId(), "name", t.getName()))
                .collect(Collectors.toList())
        );

        map.put("uCategories",
            Arrays.stream(UCategoryEnum.values())
                .map(u -> Map.of("id", u.getId(), "name", u.getName()))
                .collect(Collectors.toList())
        );

        // ✅ dCategory는 이미 id/name로 내려가고 있음
        Map<Integer, List<Map<String, Object>>> dCategoriesByU =
            Arrays.stream(DCategoryEnum.values())
                .collect(Collectors.groupingBy(
                    d -> d.getUcategory().getId(),
                    Collectors.mapping(d -> {
                        Map<String, Object> m2 = new HashMap<>();
                        m2.put("id", d.getId());
                        m2.put("name", d.getName());
                        return m2;
                    }, Collectors.toList())
                ));

        map.put("dCategoriesByU", dCategoriesByU);
        return map;
    }
}

