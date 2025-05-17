package com.zkbytebandits.convenio.service.wallet.create;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.wallet.CreateWalletRequest;
import com.zkbytebandits.convenio.dto.wallet.WalletDto;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.Wallet;
import com.zkbytebandits.convenio.mapper.wallet.WalletMapper;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.repository.wallet.WalletRepository;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CreateWallet {

    private final WalletRepository walletRepository;
    private final UserRepository userRepository;

    public WalletDto execute(CreateWalletRequest request) {
        if (walletRepository.existsByAddress(request.getAddress())) {
            throw new IllegalArgumentException("Wallet ya registrada.");
        }

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Wallet wallet = Wallet.builder()
                .user(user)
                .address(request.getAddress())
                .chain(request.getChain())
                .addedAt(LocalDateTime.now())
                .build();

        return WalletMapper.toDto(walletRepository.save(wallet));
    }
}