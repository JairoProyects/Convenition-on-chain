package com.zkbytebandits.convenio.service.convenio.update;

import com.zkbytebandits.convenio.dto.convenio.ConvenioDTO;
import com.zkbytebandits.convenio.dto.convenio.UpdateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.mapper.convenio.ConvenioMapper;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UpdateConvenioService {

    private final ConvenioRepository convenioRepository;
    private final ConvenioMapper convenioMapper;
    
    @Transactional
    public ConvenioDTO updateConvenio(Long id, UpdateConvenioRequest request) {
        Convenio convenio = convenioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Convenio not found with id: " + id));
        
        // Update entity from request
        convenioMapper.updateEntityFromRequest(convenio, request);
        
        // Set updated timestamp
        convenio.setTimestamp(LocalDateTime.now());
        
        Convenio updatedConvenio = convenioRepository.save(convenio);
        return convenioMapper.toDto(updatedConvenio);
    }
}
