package com.zkbytebandits.convenio.mapper.wallet;

import com.zkbytebandits.convenio.dto.wallet.WalletDto;
import com.zkbytebandits.convenio.entity.Wallet;

public class WalletMapper {

    private WalletMapper() {
        // Previene instanciación
    }

    public static WalletDto toDto(Wallet wallet) {
        if (wallet == null) {
            return null;
        }

        return WalletDto.builder()
                .walletId(wallet.getWalletId())
                .address(wallet.getAddress())
                .chain(wallet.getChain())
                .userId(wallet.getUser().getUserId())
                .build();
    }
}