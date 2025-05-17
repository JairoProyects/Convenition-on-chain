package com.zkbytebandits.convenio.service.wallet.update;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.wallet.UpdateWalletRequest;
import com.zkbytebandits.convenio.dto.wallet.WalletDto;
import com.zkbytebandits.convenio.entity.Wallet;
import com.zkbytebandits.convenio.mapper.wallet.WalletMapper;
import com.zkbytebandits.convenio.repository.wallet.WalletRepository;

@Service
@RequiredArgsConstructor
public class UpdateWallet {

    private final WalletRepository walletRepository;

    public WalletDto execute(Long walletId, UpdateWalletRequest request) {
        Wallet wallet = walletRepository.findById(walletId)
                .orElseThrow(() -> new RuntimeException("Wallet no encontrada"));

        wallet.setAddress(request.getAddress());
        wallet.setChain(request.getChain());

        return WalletMapper.toDto(walletRepository.save(wallet));
    }
}