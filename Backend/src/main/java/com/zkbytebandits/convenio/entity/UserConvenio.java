package com.zkbytebandits.convenio.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_convenios")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserConvenio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "convenio_id", nullable = false)
    private Convenio convenio;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime assignedAt;

    @Column(name = "role", nullable = false)
    @Enumerated(EnumType.STRING)
    private UserConvenioRole role;

    @Column(name = "status", nullable = false)
    @Enumerated(EnumType.STRING)
    private UserConvenioStatus status;

    // Enum to represent user's role in the convenio
    public enum UserConvenioRole {
        CREATOR, PARTICIPANT, SIGNER, VIEWER
    }

    // Enum to represent the status of user's participation
    public enum UserConvenioStatus {
        PENDING, ACCEPTED, REJECTED, COMPLETED
    }
}
