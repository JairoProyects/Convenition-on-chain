package com.zkbytebandits.convenio.service.userConvenio.get;

import com.zkbytebandits.convenio.dto.userConvenio.UserConvenioDto;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.UserConvenio;
import com.zkbytebandits.convenio.mapper.userConvenio.UserConvenioMapper;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.repository.userConvenio.UserConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GetUserConveniosByUser {
    
    private final UserRepository userRepository;
    private final UserConvenioRepository userConvenioRepository;
    private final UserConvenioMapper userConvenioMapper;
    
    @Transactional(readOnly = true)
    public List<UserConvenioDto> execute(Long userId) {
        // Find user by ID
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
        
        // Get all UserConvenio entities for this user
        List<UserConvenio> userConvenios = userConvenioRepository.findByUser(user);
        
        // Map to DTOs and return
        return userConvenios.stream()
                .map(userConvenioMapper::toDto)
                .collect(Collectors.toList());
    }
}
