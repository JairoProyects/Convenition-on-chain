package com.zkbytebandits.convenio.repository.contract;

import org.springframework.data.jpa.repository.JpaRepository;
import com.zkbytebandits.convenio.entity.Contract.Contract;
import java.util.List;

public interface ContractRepository extends JpaRepository<Contract, Long> {
    List<Contract> findByCreatorUserId(Long creatorUserId);
}