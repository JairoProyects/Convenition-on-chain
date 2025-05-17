package com.zkbytebandits.convenio.repository.wallet;

import org.springframework.data.jpa.repository.JpaRepository;

import com.zkbytebandits.convenio.entity.Wallet;

import java.util.List;

public interface WalletRepository extends JpaRepository<Wallet, Long> {
    List<Wallet> findByUserUserId(Long userId);
    boolean existsByAddress(String address);
}
