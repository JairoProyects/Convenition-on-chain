package com.zkbytebandits.convenio.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "audit_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "userId")
    private User user;

    @Column(name = "actor", length = 255)
    private String actor;

    @Column(nullable = false, length = 100)
    private String action; // "CONTRACT_CREATED", "SIGNATURE_ADDED"

    @Column(name = "resource_type", length = 100)
    private String resourceType; //  "Contract", "User", "Signature"

    @Column(name = "resource_id", length = 255)
    private String resourceId; // ID of the affected resource (contract ID, user ID ...ect)

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime timestamp;
    @Lob
    @Column(columnDefinition = "TEXT")
    private String details;
} 