package com.zkbytebandits.convenio.dto.wallet;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WalletDto {
    private Long walletId;
    private String address;
    private String chain;
    private Long userId;
}