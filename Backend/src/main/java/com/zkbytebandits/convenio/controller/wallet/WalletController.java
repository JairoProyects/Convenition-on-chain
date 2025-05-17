package com.zkbytebandits.convenio.controller.wallet;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.zkbytebandits.convenio.dto.wallet.CreateWalletRequest;
import com.zkbytebandits.convenio.dto.wallet.UpdateWalletRequest;
import com.zkbytebandits.convenio.dto.wallet.WalletDto;
import com.zkbytebandits.convenio.service.wallet.create.CreateWallet;
import com.zkbytebandits.convenio.service.wallet.delete.DeleteWallet;
import com.zkbytebandits.convenio.service.wallet.get.GetWalletsByUserId;
import com.zkbytebandits.convenio.service.wallet.update.UpdateWallet;

import java.util.List;

@RestController
@RequestMapping("/wallets")
@RequiredArgsConstructor
public class WalletController {

    private final CreateWallet createWallet;
    private final GetWalletsByUserId getWalletsByUserId;
    private final UpdateWallet updateWallet;
    private final DeleteWallet deleteWallet;

    @PostMapping
    public ResponseEntity<WalletDto> create(@Valid @RequestBody CreateWalletRequest request) {
        return ResponseEntity.ok(createWallet.execute(request));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<WalletDto>> getByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(getWalletsByUserId.execute(userId));
    }

    @PutMapping("/{walletId}")
    public ResponseEntity<WalletDto> update(
            @PathVariable Long walletId,
            @Valid @RequestBody UpdateWalletRequest request) {
        return ResponseEntity.ok(updateWallet.execute(walletId, request));
    }

    @DeleteMapping("/{walletId}")
    public ResponseEntity<Void> delete(@PathVariable Long walletId) {
        deleteWallet.execute(walletId);
        return ResponseEntity.noContent().build();
    }
}