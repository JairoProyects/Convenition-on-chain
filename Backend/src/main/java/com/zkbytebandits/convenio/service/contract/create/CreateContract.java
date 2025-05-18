package com.zkbytebandits.convenio.service.contract.create;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.contract.ContractDto;
import com.zkbytebandits.convenio.dto.contract.CreateContractRequest;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.Contract.Contract;
import com.zkbytebandits.convenio.mapper.contract.ContractMapper;
import com.zkbytebandits.convenio.repository.contract.ContractRepository;
import com.zkbytebandits.convenio.repository.user.UserRepository;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CreateContract {

    private final ContractRepository contractRepository;
    private final UserRepository userRepository;

    public ContractDto execute(CreateContractRequest request) {
        User user = userRepository.findById(request.getCreatorUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Contract contract = Contract.builder()
                .creator(user)
                .onchainAddress(request.getOnchainAddress())
                .classHash(request.getClassHash())
                .title(request.getTitle())
                .contentHash(request.getContentHash())
                .expirationDate(request.getExpirationDate())
                .status(Contract.Status.CREATED)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return ContractMapper.toDto(contractRepository.save(contract));
    }
}