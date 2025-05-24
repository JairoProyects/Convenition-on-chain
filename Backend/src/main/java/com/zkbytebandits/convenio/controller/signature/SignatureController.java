package com.zkbytebandits.convenio.controller.signature;

import com.zkbytebandits.convenio.service.signature.create.CreateSignatureService;
import com.zkbytebandits.convenio.service.signature.get.GetSignatureService;
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
@RequestMapping("/signatures")
public class SignatureController {

    private final CreateSignatureService createSignatureService;
    private final GetSignatureService getSignatureService;

    @Autowired
    public SignatureController(CreateSignatureService createSignatureService, GetSignatureService getSignatureService) {
        this.createSignatureService = createSignatureService;
        this.getSignatureService = getSignatureService;
    }

    @PostMapping
    public Signature saveSignature(@RequestBody Signature signature) {
        return createSignatureService.saveSignature(signature);
    }



    @GetMapping("/wallet/{walletId}")
    public List<Signature> getSignaturesByWalletId(@PathVariable Long walletId) {
        return getSignatureService.getSignaturesByWalletId(walletId);
    }
} 