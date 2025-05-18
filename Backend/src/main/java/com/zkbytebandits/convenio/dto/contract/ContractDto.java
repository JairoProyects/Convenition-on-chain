package com.zkbytebandits.convenio.dto.contract;

import lombok.*;

import java.time.LocalDateTime;

import com.zkbytebandits.convenio.entity.Contract.Contract.Status;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ContractDto {
    private Long contractId;
    private Long creatorUserId;
    private String onchainAddress;
    private String classHash;
    private String title;
    private String contentHash;
    private Status status;
    private LocalDateTime expirationDate;
}