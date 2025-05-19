package com.zkbytebandits.convenio.controller.signature;

import com.zkbytebandits.convenio.service.SignatureService;
import com.zkbytebandits.convenio.entity.Signature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/signatures")
public class SignatureController {

    private final SignatureService signatureService;

    @Autowired
    public SignatureController(SignatureService signatureService) {
        this.signatureService = signatureService;
    }

    @PostMapping
    public Signature saveSignature(@RequestBody Signature signature) {
        return signatureService.saveSignature(signature);
    }

    @GetMapping("/contract/{contractId}")
    public List<Signature> getSignaturesForContract(@PathVariable Long contractId) {
        return signatureService.getSignaturesForContract(contractId);
    }

    @GetMapping("/signer/{walletAddress}")
    public List<Signature> getSignaturesBySigner(@PathVariable String walletAddress) {
        return signatureService.getSignaturesBySigner(walletAddress);
    }
} 