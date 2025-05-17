package com.zkbytebandits.convenio.dto.wallet;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateWalletRequest {

    @NotBlank(message = "La dirección es obligatoria")
    private String address;

    @NotBlank(message = "La red es obligatoria")
    private String chain;

    @NotNull(message = "El ID del usuario es obligatorio")
    private Long userId;
}