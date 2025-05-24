package com.zkbytebandits.convenio.service.userConvenio.update;

import com.zkbytebandits.convenio.dto.userConvenio.UpdateUserConvenioRequest;
import com.zkbytebandits.convenio.dto.userConvenio.UserConvenioDto;
import com.zkbytebandits.convenio.entity.UserConvenio;
import com.zkbytebandits.convenio.mapper.userConvenio.UserConvenioMapper;
import com.zkbytebandits.convenio.repository.userConvenio.UserConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateUserConvenio {
    
    private final UserConvenioRepository userConvenioRepository;
    private final UserConvenioMapper userConvenioMapper;
    
    @Transactional
    public UserConvenioDto execute(Long id, UpdateUserConvenioRequest request) {
        // Find UserConvenio by ID
        UserConvenio userConvenio = userConvenioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserConvenio not found with ID: " + id));
        
        // Update fields if provided in the request
        if (request.getRole() != null) {
            userConvenio.setRole(request.getRole());
        }
        
        if (request.getStatus() != null) {
            userConvenio.setStatus(request.getStatus());
        }
        
        // Save updated entity
        userConvenio = userConvenioRepository.save(userConvenio);
        
        // Map to DTO and return
        return userConvenioMapper.toDto(userConvenio);
    }
}
