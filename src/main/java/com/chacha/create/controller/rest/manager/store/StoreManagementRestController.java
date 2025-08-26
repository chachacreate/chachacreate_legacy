package com.chacha.create.controller.rest.manager.store;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.entity.store.StoreEntity;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.manager.store.StoreManagementService;

@RestController
@RequestMapping("/legacy/manager")
public class StoreManagementRestController {

    @Autowired
    private StoreManagementService storeManagementService;

    @GetMapping("/stores")
    public ResponseEntity<ApiResponse<List<StoreEntity>>> storelist() {
        List<StoreEntity> stores = storeManagementService.storelist();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, stores));
    }
}

