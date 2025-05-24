package com.zkbytebandits.convenio.dto.convenio;

import com.zkbytebandits.convenio.entity.Convenio.Status;
import jakarta.validation.constraints.DecimalMin;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class UpdateConvenioRequest {
    
    private Status status;
    
    @DecimalMin(value = "0.0", inclusive = false, message = "Monto must be greater than 0")
    private BigDecimal monto;
    
    private String moneda;
    
    private String descripcion;
    
    private String condiciones;
    
    private LocalDateTime vencimiento;
    
    private List<String> firmas;
    
    private String onChainHash;
}
