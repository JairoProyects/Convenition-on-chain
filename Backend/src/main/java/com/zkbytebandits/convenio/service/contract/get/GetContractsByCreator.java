package com.zkbytebandits.convenio.service.contract.get;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.contract.ContractDto;
import com.zkbytebandits.convenio.mapper.contract.ContractMapper;
import com.zkbytebandits.convenio.repository.contract.ContractRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GetContractsByCreator {

    private final ContractRepository contractRepository;

    public List<ContractDto> execute(Long creatorUserId) {
        return contractRepository.findByCreatorUserId(creatorUserId).stream()
                .map(ContractMapper::toDto)
                .collect(Collectors.toList());
    }
}