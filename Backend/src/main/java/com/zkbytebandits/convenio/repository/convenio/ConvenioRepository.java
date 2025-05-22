package com.zkbytebandits.convenio.repository.convenio;

import com.zkbytebandits.convenio.entity.Convenio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConvenioRepository extends JpaRepository<Convenio, Long> {
    Optional<Convenio> findByExternalId(String externalId);
    Optional<Convenio> findByOnChainHash(String onChainHash);
    // Add other custom query methods if needed, for example, find by certain criteria
} 