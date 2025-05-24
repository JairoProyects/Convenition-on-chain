package com.zkbytebandits.convenio.repository.convenio;

import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.Convenio.Status;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConvenioRepository extends JpaRepository<Convenio, Long> {
    
    List<Convenio> findByStatus(Status status);
    
    Optional<Convenio> findByOnChainHash(String onChainHash);

}
