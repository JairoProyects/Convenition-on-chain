package com.zkbytebandits.convenio.service.convenio.create;

import com.zkbytebandits.convenio.dto.convenio.CreateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CreateConvenioService {

    private final ConvenioRepository convenioRepository;

    @Autowired
    public CreateConvenioService(ConvenioRepository convenioRepository) {
        this.convenioRepository = convenioRepository;
    }

    @Transactional
    public Convenio createConvenio(CreateConvenioRequest request) {
        // Consider adding checks for existing externalId or onChainHash if they must be unique
        // and you want to provide specific error messages before a DB constraint violation.

        Convenio convenio = Convenio.builder()
                .externalId(request.getExternalId())
                .monto(request.getMonto())
                .moneda(request.getMoneda())
                .descripcion(request.getDescripcion())
                .condiciones(request.getCondiciones())
                .vencimiento(request.getVencimiento())
                .firmas(request.getFirmas())
                .onChainHash(request.getOnChainHash())
                // timestamp is handled by @CreationTimestamp
                .build();
        return convenioRepository.save(convenio);
    }
} 