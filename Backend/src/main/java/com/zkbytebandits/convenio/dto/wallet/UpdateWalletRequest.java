package com.zkbytebandits.convenio.dto.wallet;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateWalletRequest {

    @NotBlank(message = "La dirección no puede estar vacía")
    private String address;

    @NotBlank(message = "La red no puede estar vacía")
    private String chain;
}