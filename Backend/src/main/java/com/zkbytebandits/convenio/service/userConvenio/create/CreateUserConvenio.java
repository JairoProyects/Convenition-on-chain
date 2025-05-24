package com.zkbytebandits.convenio.service.userConvenio.create;

import com.zkbytebandits.convenio.dto.userConvenio.CreateUserConvenioRequest;
import com.zkbytebandits.convenio.dto.userConvenio.UserConvenioDto;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.UserConvenio;
import com.zkbytebandits.convenio.mapper.userConvenio.UserConvenioMapper;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.repository.userConvenio.UserConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateUserConvenio {
    
    private final UserRepository userRepository;
    private final ConvenioRepository convenioRepository;
    private final UserConvenioRepository userConvenioRepository;
    private final UserConvenioMapper userConvenioMapper;
    
    @Transactional
    public UserConvenioDto execute(CreateUserConvenioRequest request) {
        // Find user and convenio by their IDs
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + request.getUserId()));
        
        Convenio convenio = convenioRepository.findById(request.getConvenioId())
                .orElseThrow(() -> new RuntimeException("Convenio not found with ID: " + request.getConvenioId()));
        
        // Check if the relationship already exists
        if (userConvenioRepository.existsByUserAndConvenio(user, convenio)) {
            throw new RuntimeException("User is already associated with this convenio");
        }
        
        // Create new UserConvenio entity
        UserConvenio userConvenio = UserConvenio.builder()
                .user(user)
                .convenio(convenio)
                .role(request.getRole())
                .status(request.getStatus())
                .build();
        
        // Save the entity
        userConvenio = userConvenioRepository.save(userConvenio);
        
        // Map to DTO and return
        return userConvenioMapper.toDto(userConvenio);
    }
}
