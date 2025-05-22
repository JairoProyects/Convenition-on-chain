package com.zkbytebandits.convenio.service.convenio.delete;

import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DeleteConvenioService {

    private final ConvenioRepository convenioRepository;

    @Autowired
    public DeleteConvenioService(ConvenioRepository convenioRepository) {
        this.convenioRepository = convenioRepository;
    }

    @Transactional
    public void deleteConvenio(Long id) {
        if (!convenioRepository.existsById(id)) {
            throw new EntityNotFoundException("Convenio not found with id: " + id);
        }
        convenioRepository.deleteById(id);
    }
} 