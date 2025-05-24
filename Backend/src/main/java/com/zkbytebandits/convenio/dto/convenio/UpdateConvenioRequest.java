package com.zkbytebandits.convenio.dto.convenio;

import com.zkbytebandits.convenio.entity.Convenio.Status;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class UpdateConvenioRequest {
    // Fields are optional for update
    private Status status;

    @DecimalMin(value = "0.0", inclusive = false, message = "Monto must be positive")
    private BigDecimal monto;

    @Size(max = 10, message = "Moneda cannot exceed 10 characters")
    private String moneda;

    private String descripcion;

    private String condiciones;

    private LocalDateTime vencimiento;

    private List<String> firmas;

    private String onChainHash;
} 