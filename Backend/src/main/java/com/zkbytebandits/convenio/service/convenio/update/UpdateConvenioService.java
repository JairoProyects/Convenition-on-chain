package com.zkbytebandits.convenio.service.convenio.update;

import com.zkbytebandits.convenio.dto.convenio.UpdateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;

import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UpdateConvenioService {

    private final ConvenioRepository convenioRepository;

    @Autowired
    public UpdateConvenioService(ConvenioRepository convenioRepository) {
        this.convenioRepository = convenioRepository;
    }

    @Transactional
    public Convenio updateConvenio(Long id, UpdateConvenioRequest request) {
        Convenio convenio = convenioRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Convenio not found with id: " + id));

        // Update fields if they are present in the request
        if (request.getStatus() != null) {
            convenio.setStatus(request.getStatus());
        }
        if (request.getMonto() != null) {
            convenio.setMonto(request.getMonto());
        }
        if (request.getMoneda() != null) {
            convenio.setMoneda(request.getMoneda());
        }
        if (request.getDescripcion() != null) {
            convenio.setDescripcion(request.getDescripcion());
        }
        if (request.getCondiciones() != null) {
            convenio.setCondiciones(request.getCondiciones());
        }
        if (request.getVencimiento() != null) {
            convenio.setVencimiento(request.getVencimiento());
        }
        if (request.getFirmas() != null && !request.getFirmas().isEmpty()) {
            convenio.setFirmas(request.getFirmas());
        }
        if (request.getOnChainHash() != null) {
            convenio.setOnChainHash(request.getOnChainHash());
        }

        return convenioRepository.save(convenio);
    }
} 