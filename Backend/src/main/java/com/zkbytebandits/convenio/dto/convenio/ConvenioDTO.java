package com.zkbytebandits.convenio.dto.convenio;

import com.zkbytebandits.convenio.entity.Convenio.Status;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConvenioDTO {
    private Long id;
    private Status status;
    private LocalDateTime timestamp;
    private BigDecimal monto;
    private String moneda;
    private String descripcion;
    private String condiciones;
    private LocalDateTime vencimiento;
    private List<String> firmas;
    private String onChainHash;
}
