package com.chacha.create.util;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ServiceUtil {
	
    public static void putParsedParam(Map<String, Object> params, String key, List<String> values) {
        if (values != null && !values.isEmpty()) {
            List<Integer> parsedList = values.stream()
                                             .map(Integer::parseInt)
                                             .collect(Collectors.toList());
            params.put(key, parsedList);
        }
    }

    // 카드 번호 보안(뒤 네 자리만 나오도록)
    public static String maskCardNumber(String cardNum) {
        if (cardNum == null || cardNum.length() < 4) return "";
        return "****-****-****-" + cardNum.substring(cardNum.length() - 4);
	}
    
}
