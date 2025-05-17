package com.zkbytebandits.convenio.service.wallet.get;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.dto.wallet.WalletDto;
import com.zkbytebandits.convenio.mapper.wallet.WalletMapper;
import com.zkbytebandits.convenio.repository.wallet.WalletRepository;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GetWalletsByUserId {

    private final WalletRepository walletRepository;

    public List<WalletDto> execute(Long userId) {
        return walletRepository.findByUserUserId(userId).stream()
                .map(WalletMapper::toDto)
                .collect(Collectors.toList());
    }
}