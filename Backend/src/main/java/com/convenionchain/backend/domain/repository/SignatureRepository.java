package com.convenionchain.backend.domain.repository;

import com.convenionchain.backend.domain.entity.Signature;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SignatureRepository extends JpaRepository<Signature, Long> {

    // Find signatures by contract ID
    List<Signature> findByContractId(Long contractId);

    //  Find signatures by signer's wallet address
    List<Signature> findBySignerWalletAddress(String walletAddress);

} 