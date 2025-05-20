package com.zkbytebandits.convenio.service.signature.get;

import com.zkbytebandits.convenio.entity.Signature;
import com.zkbytebandits.convenio.repository.signature.SignatureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GetSignatureService {

    private final SignatureRepository signatureRepository;

    @Autowired
    public GetSignatureService(SignatureRepository signatureRepository) {
        this.signatureRepository = signatureRepository;
    }

    @Transactional(readOnly = true)
    public List<Signature> getSignaturesForContract(Long contractId) {
        return signatureRepository.findByContractContractId(contractId);
    }

    @Transactional(readOnly = true)
    public List<Signature> getSignaturesByWalletId(Long walletId) {
        return signatureRepository.findByWalletWalletId(walletId);
    }
} 