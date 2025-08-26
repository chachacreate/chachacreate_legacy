package com.chacha.create.controller.rest.manager.adjustment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chacha.create.common.dto.error.ApiResponse;
import com.chacha.create.common.dto.manager.ManagerAdjustmentDTO;
import com.chacha.create.common.enums.error.ResponseCode;
import com.chacha.create.service.manager.adjustment.AdjustmentService;

@RestController
@RequestMapping("/legacy/manager/adjustment")
public class AdjustmentRestController {

    @Autowired
    private AdjustmentService adjustmentService;

    @GetMapping("/store")
    public ResponseEntity<ApiResponse<List<ManagerAdjustmentDTO>>> storeAdjustment() {
        List<ManagerAdjustmentDTO> list = adjustmentService.storeAdjustment();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, list));
    }

    @GetMapping("/seller")
    public ResponseEntity<ApiResponse<List<ManagerAdjustmentDTO>>> sellerAdjustment() {
        List<ManagerAdjustmentDTO> list = adjustmentService.sellerAdjustment();
        return ResponseEntity.ok(new ApiResponse<>(ResponseCode.OK, list));
    }
}
