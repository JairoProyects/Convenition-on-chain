package com.zkbytebandits.convenio.repository.signature;

import com.zkbytebandits.convenio.entity.Signature;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SignatureRepository extends JpaRepository<Signature, Long> {

    // Find signatures by contract ID
    List<Signature> findByContractContractId(Long contractId);

    // Find signatures by signer's wallet ID
    List<Signature> findByWalletWalletId(Long walletId);

} 