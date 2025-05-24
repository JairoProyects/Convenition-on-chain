package com.zkbytebandits.convenio.service.userConvenio.delete;

import com.zkbytebandits.convenio.repository.userConvenio.UserConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteUserConvenio {
    
    private final UserConvenioRepository userConvenioRepository;
    
    @Transactional
    public void execute(Long id) {
        // Check if UserConvenio exists
        if (!userConvenioRepository.existsById(id)) {
            throw new RuntimeException("UserConvenio not found with ID: " + id);
        }
        
        // Delete the UserConvenio
        userConvenioRepository.deleteById(id);
    }
    
    @Transactional
    public void executeByUserAndConvenio(Long userId, Long convenioId) {
        // Delete all relationships between the user and convenio
        userConvenioRepository.findAll().stream()
                .filter(uc -> uc.getUser().getUserId().equals(userId) && uc.getConvenio().getId().equals(convenioId))
                .forEach(uc -> userConvenioRepository.deleteById(uc.getId()));
    }
}
