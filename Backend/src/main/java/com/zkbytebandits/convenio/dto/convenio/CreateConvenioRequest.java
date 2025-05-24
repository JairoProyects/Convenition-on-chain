package com.zkbytebandits.convenio.dto.convenio;

import com.zkbytebandits.convenio.entity.Convenio.Status;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CreateConvenioRequest {
    
    @NotNull(message = "Status is required")
    private Status status;
    
    @NotNull(message = "Monto is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Monto must be greater than 0")
    private BigDecimal monto;
    
    @NotBlank(message = "Moneda is required")
    private String moneda;
    
    @NotBlank(message = "Descripcion is required")
    private String descripcion;
    
    @NotBlank(message = "Condiciones is required")
    private String condiciones;
    
    @NotNull(message = "Vencimiento is required")
    private LocalDateTime vencimiento;
    
 //   private List<String> firmas;
    
    private String onChainHash;
}
