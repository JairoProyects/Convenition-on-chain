package com.zkbytebandits.convenio.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

// Assuming Contract entity is com.zkbytebandits.convenio.entity.Contract.Contract

// Assuming Wallet entity is com.zkbytebandits.convenio.entity.Wallet
import com.zkbytebandits.convenio.entity.Wallet;
// Assuming User entity is com.zkbytebandits.convenio.entity.User
import com.zkbytebandits.convenio.entity.User;

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
    @JoinColumn(name = "wallet_id", nullable = false) // FK to Wallet
    private Wallet wallet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false) // FK to User
    private User user;

    @Lob // For potentially large signature data
    @Column(name = "signature_data", nullable = false, columnDefinition = "TEXT")
    private String signatureData;

    @CreationTimestamp
    @Column(name = "signed_at", nullable = false, updatable = false)
    private LocalDateTime signedAt;
} 