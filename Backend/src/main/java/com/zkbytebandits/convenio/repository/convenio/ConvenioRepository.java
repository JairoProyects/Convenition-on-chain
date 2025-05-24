package com.zkbytebandits.convenio.repository.convenio;

import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.Convenio.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConvenioRepository extends JpaRepository<Convenio, Long> {
    Optional<Convenio> findByOnChainHash(String onChainHash);
    List<Convenio> findByStatus(Status status);
    // Add other custom query methods if needed, for example, find by certain criteria
}