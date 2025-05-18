package com.zkbytebandits.convenio.dto.contract;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CreateContractRequest {
    @NotNull
    private Long creatorUserId;

    private String onchainAddress;
    private String classHash;

    @NotBlank
    private String title;

    @NotBlank
    private String contentHash;

    private LocalDateTime expirationDate;
}
