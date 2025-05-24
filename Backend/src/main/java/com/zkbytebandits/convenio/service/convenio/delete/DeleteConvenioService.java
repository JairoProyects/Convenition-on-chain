package com.zkbytebandits.convenio.service.convenio.delete;

import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteConvenioService {

    private final ConvenioRepository convenioRepository;
    
    @Transactional
    public void deleteConvenio(Long id) {
        if (!convenioRepository.existsById(id)) {
            throw new RuntimeException("Convenio not found with id: " + id);
        }
        
        convenioRepository.deleteById(id);
    }
}
