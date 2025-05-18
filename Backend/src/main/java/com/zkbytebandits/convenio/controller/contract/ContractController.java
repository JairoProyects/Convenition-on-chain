package com.zkbytebandits.convenio.controller.contract;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.zkbytebandits.convenio.dto.contract.ContractDto;
import com.zkbytebandits.convenio.dto.contract.CreateContractRequest;
import com.zkbytebandits.convenio.dto.contract.UpdateContractRequest;
import com.zkbytebandits.convenio.service.contract.create.CreateContract;
import com.zkbytebandits.convenio.service.contract.delete.DeleteContract;
import com.zkbytebandits.convenio.service.contract.get.GetContractsByCreator;
import com.zkbytebandits.convenio.service.contract.update.UpdateContract;

import java.util.List;

@RestController
@RequestMapping("/contracts")
@RequiredArgsConstructor
public class ContractController {

    private final CreateContract createContract;
    private final GetContractsByCreator getContractsByCreator;
    private final UpdateContract updateContract;
    private final DeleteContract deleteContract;

    @PostMapping
    public ResponseEntity<ContractDto> create(@Valid @RequestBody CreateContractRequest request) {
        return ResponseEntity.ok(createContract.execute(request));
    }

    @GetMapping("/creator/{userId}")
    public ResponseEntity<List<ContractDto>> getByCreator(@PathVariable Long userId) {
        return ResponseEntity.ok(getContractsByCreator.execute(userId));
    }

    @PutMapping("/{contractId}")
    public ResponseEntity<ContractDto> update(
            @PathVariable Long contractId,
            @Valid @RequestBody UpdateContractRequest request) {
        return ResponseEntity.ok(updateContract.execute(contractId, request));
    }

    @DeleteMapping("/{contractId}")
    public ResponseEntity<Void> delete(@PathVariable Long contractId) {
        deleteContract.execute(contractId);
        return ResponseEntity.noContent().build();
    }
}