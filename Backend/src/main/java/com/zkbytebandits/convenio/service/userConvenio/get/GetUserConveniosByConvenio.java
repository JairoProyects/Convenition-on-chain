package com.zkbytebandits.convenio.service.userConvenio.get;

import com.zkbytebandits.convenio.dto.userConvenio.UserConvenioDto;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.UserConvenio;
import com.zkbytebandits.convenio.mapper.userConvenio.UserConvenioMapper;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import com.zkbytebandits.convenio.repository.userConvenio.UserConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GetUserConveniosByConvenio {
    
    private final ConvenioRepository convenioRepository;
    private final UserConvenioRepository userConvenioRepository;
    private final UserConvenioMapper userConvenioMapper;
    
    @Transactional(readOnly = true)
    public List<UserConvenioDto> execute(Long convenioId) {
        // Find convenio by ID
        Convenio convenio = convenioRepository.findById(convenioId)
                .orElseThrow(() -> new RuntimeException("Convenio not found with ID: " + convenioId));
        
        // Get all UserConvenio entities for this convenio
        List<UserConvenio> userConvenios = userConvenioRepository.findByConvenio(convenio);
        
        // Map to DTOs and return
        return userConvenios.stream()
                .map(userConvenioMapper::toDto)
                .collect(Collectors.toList());
    }
}
