package com.zkbytebandits.convenio.dto.convenio;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CreateConvenioRequest {

    // Status will be set automatically to CREATED

    @NotNull(message = "Monto cannot be null")
    @DecimalMin(value = "0.0", inclusive = false, message = "Monto must be positive")
    private BigDecimal monto;

    @NotBlank(message = "Moneda cannot be blank")
    @Size(max = 10, message = "Moneda cannot exceed 10 characters")
    private String moneda;

    @NotBlank(message = "Descripcion cannot be blank")
    private String descripcion;

    @NotBlank(message = "Condiciones cannot be blank")
    private String condiciones;

    @NotNull(message = "Vencimiento cannot be null")
    private LocalDateTime vencimiento;

    @NotEmpty(message = "Firmas cannot be empty")
    private List<String> firmas;

    @NotBlank(message = "On-chain hash cannot be blank")
    private String onChainHash;
} 