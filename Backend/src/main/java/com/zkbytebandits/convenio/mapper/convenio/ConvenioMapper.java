package com.zkbytebandits.convenio.mapper.convenio;

import com.zkbytebandits.convenio.dto.convenio.ConvenioResponse;
import com.zkbytebandits.convenio.entity.Convenio;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
public class ConvenioMapper {

    public ConvenioResponse toConvenioResponse(Convenio convenio) {
        if (convenio == null) {
            return null;
        }
        return ConvenioResponse.builder()
                .id(convenio.getId())
                .externalId(convenio.getExternalId())
                .timestamp(convenio.getTimestamp())
                .monto(convenio.getMonto())
                .moneda(convenio.getMoneda())
                .descripcion(convenio.getDescripcion())
                .condiciones(convenio.getCondiciones())
                .vencimiento(convenio.getVencimiento())
                .firmas(convenio.getFirmas() != null ? convenio.getFirmas() : null) // defensive copy or immutable list might be better
                .onChainHash(convenio.getOnChainHash())
                .build();
    }

    // We might not need a toConvenioEntity from ConvenioResponse if all creations/updates go through specific request DTOs
} 