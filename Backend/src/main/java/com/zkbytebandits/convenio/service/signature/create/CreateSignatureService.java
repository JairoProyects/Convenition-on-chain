package com.zkbytebandits.convenio.service.signature.create;

import com.zkbytebandits.convenio.entity.Signature;
import com.zkbytebandits.convenio.repository.signature.SignatureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CreateSignatureService {

    private final SignatureRepository signatureRepository;

    @Autowired
    public CreateSignatureService(SignatureRepository signatureRepository) {
        this.signatureRepository = signatureRepository;
    }

    @Transactional
    public Signature saveSignature(Signature signature) {
        // Add any business logic here before saving, e.g.:
        // - Validate the signature (e.g., check if the signer is authorized)
        // - Check if the contract exists and is in a state that allows signing
        // - Prevent duplicate signatures for the same contract by the same signer

        // For now, just save it as per original logic
        return signatureRepository.save(signature);
    }
    
    // The commented out recordSignature method from the original service could be added here if needed.
    // For example:
    /*
    @Transactional
    public Signature recordSignature(Long contractId, com.zkbytebandits.convenio.entity.User user, com.zkbytebandits.convenio.entity.Wallet wallet, String signatureData) {
        // Logic from the original SignatureService's commented out method
        // Contract contract = contractRepository.findById(contractId)
        // .orElseThrow(() -> new RuntimeException("Contract not found: " + contractId));

        Signature signatureToSave = Signature.builder()
            // .contract(contract) // Link to the actual Contract object
            .user(user)
            .wallet(wallet)
            .signatureData(signatureData)
            .build();
        
        Signature savedSignature = signatureRepository.save(signatureToSave);
        // starkNetService.invokeSignConvenio(contract.getOnChainId(), signatureData);
        return savedSignature;
    }
    */
} 