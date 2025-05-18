package com.zkbytebandits.convenio.dto.contract;

import lombok.Data;
import java.time.LocalDateTime;
import com.zkbytebandits.convenio.entity.Contract.Contract.Status;

@Data
public class UpdateContractRequest {
    private String title;
    private String contentHash;
    private Status status;
    private LocalDateTime expirationDate;
}