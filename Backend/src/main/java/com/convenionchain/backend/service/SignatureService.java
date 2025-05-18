package com.zkbytebandits.convenio.service;

import com.zkbytebandits.convenio.entity.Signature;
import com.zkbytebandits.convenio.repository.SignatureRepository;
// Import Contract entity when available
// import com.zkbytebandits.convenio.entity.Contract.Contract;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SignatureService {

    private final SignatureRepository signatureRepository;
    // private final com.zkbytebandits.convenio.repository.ContractRepository contractRepository; // Example for updated ContractRepository path

    @Autowired
    public SignatureService(SignatureRepository signatureRepository) {
        this.signatureRepository = signatureRepository;
    }

    @Transactional
    public Signature saveSignature(Signature signature) {
        // Add any business logic here before saving, e.g.:
        // - Validate the signature (e.g., check if the signer is authorized)
        // - Check if the contract exists and is in a state that allows signing
        // - Prevent duplicate signatures for the same contract by the same signer

        // For now, just save it
        return signatureRepository.save(signature);
    }

    @Transactional(readOnly = true)
    public List<Signature> getSignaturesForContract(Long contractId) {
        return signatureRepository.findByContractId(contractId);
    }

    @Transactional(readOnly = true)
    public List<Signature> getSignaturesBySigner(String walletAddress) {
        return signatureRepository.findBySignerWalletAddress(walletAddress);
    }

    // Potentially, a more complex method for the full signing process:
    /*
    @Transactional
    public Signature recordSignature(Long contractId, String signerWalletAddress, String signatureData) {
        // 1. Fetch the contract (requires Contract entity and repository)
        // Contract contract = contractRepository.findById(contractId)
        // .orElseThrow(() -> new RuntimeException("Contract not found: " + contractId));

        // 2. Validate (e.g., contract status, signer eligibility, etc.)
        // if (!contract.canBeSignedBy(signerWalletAddress)) {
        // throw new RuntimeException("Signature not allowed or already signed by this user");
        // }

        // 3. Create and save the signature
        Signature signature = Signature.builder()
            // .contract(contract) // Link to the actual Contract object
            .signerWalletAddress(signerWalletAddress)
            .signatureData(signatureData)
            .build();

        Signature savedSignature = signatureRepository.save(signature);

        // 4. Potentially update contract status
        // contract.addSignature(savedSignature);
        // contractRepository.save(contract);

        // 5. Call StarkNet to record the signature on-chain (as per requirements.md)
        // starkNetService.invokeSignConvenio(contract.getOnChainId(), signatureData);

        return savedSignature;
    }
    */
} 