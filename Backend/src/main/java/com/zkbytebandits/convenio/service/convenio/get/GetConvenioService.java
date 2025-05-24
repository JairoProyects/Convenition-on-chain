package com.zkbytebandits.convenio.service.convenio.get;

import com.zkbytebandits.convenio.dto.convenio.ConvenioDTO;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.Convenio.Status;
import com.zkbytebandits.convenio.mapper.convenio.ConvenioMapper;
import com.zkbytebandits.convenio.repository.convenio.ConvenioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
@RequiredArgsConstructor
public class GetConvenioService {

    private static final Logger logger = LoggerFactory.getLogger(GetConvenioService.class);
    private final ConvenioRepository convenioRepository;
    private final ConvenioMapper convenioMapper;

    //@Transactional(readOnly = true)
    public List<ConvenioDTO> getAllConvenios() {

        return convenioRepository.findAll().stream().map(convenioMapper::toDto).collect(Collectors.toList());


//        logger.info("Attempting to fetch all convenios.");
//        List<Convenio> convenios;
//        try {
//            convenios = convenioRepository.findAll();
//            logger.info("Successfully fetched {} convenios from repository.", convenios.size());
//        } catch (Exception e) {
//            logger.error("Error fetching convenios from repository: ", e);
//            throw e; // Re-throw to allow Spring to handle it, will result in 500
//        }
//
//        return convenios.stream()
//                .map(convenio -> {
//                    logger.debug("Mapping convenio with ID: {}", convenio.getId());
//                    try {
//                        ConvenioDTO dto = convenioMapper.toDto(convenio);
//                        logger.debug("Successfully mapped convenio with ID: {}", convenio.getId());
//                        return dto;
//                    } catch (Exception e) {
//                        logger.error("Error mapping convenio with ID {}: ", convenio.getId(), e);
//                        // Optionally, you could return null or a special error DTO here
//                        // and filter out nulls later, to allow other convenios to be returned.
//                        // For now, let it propagate to see the error.
//                        throw new RuntimeException("Error mapping convenio ID " + convenio.getId(), e);
//                    }
//                })
//                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ConvenioDTO getConvenioById(Long id) {
        logger.info("Attempting to fetch convenio by ID: {}", id);
        Convenio convenio = convenioRepository.findById(id)
                .orElseThrow(() -> {
                    logger.warn("Convenio not found with ID: {}", id);
                    return new RuntimeException("Convenio not found with id: " + id);
                });
        logger.info("Successfully fetched convenio with ID: {}", id);
        return convenioMapper.toDto(convenio);
    }

    @Transactional(readOnly = true)
    public List<ConvenioDTO> getConveniosByStatus(Status status) {
        logger.info("Attempting to fetch convenios by status: {}", status);
        List<Convenio> convenios = convenioRepository.findByStatus(status);
        logger.info("Successfully fetched {} convenios with status: {}", convenios.size(), status);
        return convenios.stream()
                .map(convenioMapper::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ConvenioDTO getConvenioByOnChainHash(String onChainHash) {
        logger.info("Attempting to fetch convenio by onChainHash: {}", onChainHash);
        Convenio convenio = convenioRepository.findByOnChainHash(onChainHash)
                .orElseThrow(() -> {
                    logger.warn("Convenio not found with onChainHash: {}", onChainHash);
                    return new RuntimeException("Convenio not found with onChainHash: " + onChainHash);
                });
        logger.info("Successfully fetched convenio with onChainHash: {}", onChainHash);
        return convenioMapper.toDto(convenio);
    }
}
