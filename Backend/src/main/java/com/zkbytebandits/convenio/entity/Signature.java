package com.zkbytebandits.convenio.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

// Assuming Contract entity is com.zkbytebandits.convenio.entity.Contract.Contract
import com.zkbytebandits.convenio.entity.Contract.Contract;

import java.time.LocalDateTime;

@Entity
@Table(name = "signatures")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Signature {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contract_id", nullable = false)
    private Contract contract;

    @Column(name = "signer_wallet_address", nullable = false, length = 255) // Fk del wallet
    private String signerWalletAddress;

    // User who signed the contract

    @Lob // For potentially large signature data
    @Column(name = "signature_data", nullable = false, columnDefinition = "TEXT")
    private String signatureData;

    @CreationTimestamp
    @Column(name = "signed_at", nullable = false, updatable = false)
    private LocalDateTime signedAt;
} 