package com.zkbytebandits.convenio.entity.Contract;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

import com.zkbytebandits.convenio.entity.User;

@Entity
@Table(name = "contracts")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Contract {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long contractId;

    @ManyToOne
    @JoinColumn(name = "creator_user_id", nullable = false)
    private User creator;

    private String onchainAddress;
    private String classHash;
    private String title;
    private String contentHash;
    private LocalDateTime expirationDate;

    @Enumerated(EnumType.STRING)
    private Status status;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum Status {
        CREATED,
        SIGNED_BY_ONE,
        COMPLETED,
        EXPIRED
    }
}