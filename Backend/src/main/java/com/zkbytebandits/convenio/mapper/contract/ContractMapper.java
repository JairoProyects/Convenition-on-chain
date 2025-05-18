package com.zkbytebandits.convenio.mapper.contract;

import com.zkbytebandits.convenio.dto.contract.ContractDto;
import com.zkbytebandits.convenio.entity.Contract.Contract;

public class ContractMapper {

    private ContractMapper() {}

    public static ContractDto toDto(Contract c) {
        if (c == null) return null;

        return ContractDto.builder()
                .contractId(c.getContractId())
                .creatorUserId(c.getCreator().getUserId())
                .onchainAddress(c.getOnchainAddress())
                .classHash(c.getClassHash())
                .title(c.getTitle())
                .contentHash(c.getContentHash())
                .status(c.getStatus())
                .expirationDate(c.getExpirationDate())
                .build();
    }
}