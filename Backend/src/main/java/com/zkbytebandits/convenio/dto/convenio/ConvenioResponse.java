package com.zkbytebandits.convenio.dto.convenio;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class ConvenioResponse {
    private Long id; // Internal DB id
    private String externalId;
    private LocalDateTime timestamp;
    private BigDecimal monto;
    private String moneda;
    private String descripcion;
    private String condiciones;
    private LocalDateTime vencimiento;
    private List<String> firmas;
    private String onChainHash;
} 