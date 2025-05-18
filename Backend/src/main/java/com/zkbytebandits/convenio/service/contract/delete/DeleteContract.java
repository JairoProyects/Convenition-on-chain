package com.zkbytebandits.convenio.service.contract.delete;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.repository.contract.ContractRepository;

@Service
@RequiredArgsConstructor
public class DeleteContract {

    private final ContractRepository contractRepository;

    public void execute(Long contractId) {
        contractRepository.deleteById(contractId);
    }
}