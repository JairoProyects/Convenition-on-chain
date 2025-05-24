package com.zkbytebandits.convenio.service.convenio.get;

import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.Convenio.Status;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class GetConvenioService {

    private final ConvenioRepository convenioRepository;

    @Autowired
    public GetConvenioService(ConvenioRepository convenioRepository) {
        this.convenioRepository = convenioRepository;
    }

    @Transactional(readOnly = true)
    public Page<Convenio> getAllConvenios(Pageable pageable) {
        return convenioRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Optional<Convenio> getConvenioById(Long id) {
        return convenioRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public List<Convenio> getConveniosByStatus(Status status) {
        return convenioRepository.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public Optional<Convenio> getConvenioByOnChainHash(String onChainHash) {
        return convenioRepository.findByOnChainHash(onChainHash);
    }

} 