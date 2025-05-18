package com.zkbytebandits.convenio.service.contract.update;

import lombok.RequiredArgsConstructor;


import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.contract.ContractDto;
import com.zkbytebandits.convenio.dto.contract.UpdateContractRequest;
import com.zkbytebandits.convenio.entity.Contract.Contract;
import com.zkbytebandits.convenio.mapper.contract.ContractMapper;
import com.zkbytebandits.convenio.repository.contract.ContractRepository;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UpdateContract {

    private final ContractRepository contractRepository;

    public ContractDto execute(Long contractId, UpdateContractRequest request) {
        Contract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new RuntimeException("Contrato no encontrado"));

        contract.setTitle(request.getTitle());
        contract.setContentHash(request.getContentHash());
        contract.setStatus(request.getStatus());
        contract.setExpirationDate(request.getExpirationDate());
        contract.setUpdatedAt(LocalDateTime.now());

        return ContractMapper.toDto(contractRepository.save(contract));
    }
}