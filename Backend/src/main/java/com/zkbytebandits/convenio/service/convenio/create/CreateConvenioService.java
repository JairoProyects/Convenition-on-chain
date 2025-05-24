package com.zkbytebandits.convenio.service.convenio.create;

import com.zkbytebandits.convenio.dto.convenio.ConvenioDTO;
import com.zkbytebandits.convenio.dto.convenio.CreateConvenioRequest;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.mapper.convenio.ConvenioMapper;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CreateConvenioService {

    private final ConvenioRepository convenioRepository;
    private final ConvenioMapper convenioMapper;
    
    @Transactional
    public ConvenioDTO createConvenio(CreateConvenioRequest request) {
        Convenio convenio = convenioMapper.toEntity(request);
        
        // Set the creation timestamp if not provided
        if (convenio.getTimestamp() == null) {
            convenio.setTimestamp(LocalDateTime.now());
        }
        
        Convenio savedConvenio = convenioRepository.save(convenio);
        return convenioMapper.toDto(savedConvenio);
    }
}
