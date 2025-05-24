package com.zkbytebandits.convenio.mapper.convenio;

import com.zkbytebandits.convenio.dto.convenio.ConvenioDTO;
import com.zkbytebandits.convenio.dto.convenio.CreateConvenioRequest;
import com.zkbytebandits.convenio.dto.convenio.UpdateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;
import org.springframework.stereotype.Component;
import java.util.ArrayList;

import java.util.ArrayList;
import java.util.Collections;

@Component
public class ConvenioMapper {

    /**
     * Convert a Convenio entity to a ConvenioDTO
     */
    public ConvenioDTO toDto(Convenio entity) {
        if (entity == null) {
            return null;
        }
        
        return ConvenioDTO.builder()
                .id(entity.getId())
                .status(entity.getStatus())
                .timestamp(entity.getTimestamp())
                .monto(entity.getMonto())
                .moneda(entity.getMoneda())
                .descripcion(entity.getDescripcion())
                .condiciones(entity.getCondiciones())
                .vencimiento(entity.getVencimiento())
                //.firmas(entity.getFirmas() != null ? new ArrayList<>(entity.getFirmas()) : Collections.emptyList())
                .onChainHash(entity.getOnChainHash())
                .build();
    }
    
    /**
     * Convert a CreateConvenioRequest to a Convenio entity
     */
    public Convenio toEntity(CreateConvenioRequest request) {
        if (request == null) {
            return null;
        }
        
        Convenio entity = new Convenio();
        entity.setStatus(request.getStatus());
        entity.setMonto(request.getMonto());
        entity.setMoneda(request.getMoneda());
        entity.setDescripcion(request.getDescripcion());
        entity.setCondiciones(request.getCondiciones());
        entity.setVencimiento(request.getVencimiento());
//        entity.setFirmas(request.getFirmas() != null ? request.getFirmas() : Collections.emptyList());
        entity.setOnChainHash(request.getOnChainHash());
        
        return entity;
    }
    
    /**
     * Update a Convenio entity with UpdateConvenioRequest
     */
    public void updateEntityFromRequest(Convenio entity, UpdateConvenioRequest request) {
        if (entity == null || request == null) {
            return;
        }
        
        if (request.getStatus() != null) {
            entity.setStatus(request.getStatus());
        }
        
        if (request.getMonto() != null) {
            entity.setMonto(request.getMonto());
        }
        
        if (request.getMoneda() != null) {
            entity.setMoneda(request.getMoneda());
        }
        
        if (request.getDescripcion() != null) {
            entity.setDescripcion(request.getDescripcion());
        }
        
        if (request.getCondiciones() != null) {
            entity.setCondiciones(request.getCondiciones());
        }
        
        if (request.getVencimiento() != null) {
            entity.setVencimiento(request.getVencimiento());
        }
        
//        if (request.getFirmas() != null) {
//            entity.setFirmas(request.getFirmas());
//        }
//
        if (request.getOnChainHash() != null) {
            entity.setOnChainHash(request.getOnChainHash());
        }
    }
}
