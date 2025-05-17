package com.zkbytebandits.convenio.service.wallet.delete;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.repository.wallet.WalletRepository;

@Service
@RequiredArgsConstructor
public class DeleteWallet {

    private final WalletRepository walletRepository;

    public void execute(Long walletId) {
        walletRepository.deleteById(walletId);
    }
}