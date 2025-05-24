package com.zkbytebandits.convenio.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "convenios")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Convenio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private Status status;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime timestamp;

    @Column(nullable = false, precision = 19, scale = 4) // Adjust precision and scale as needed
    private BigDecimal monto;

    @Column(nullable = false, length = 10)
    private String moneda;

    @Column(nullable = false)
    private String descripcion;

    @Lob
    @Column(nullable = false, columnDefinition = "TEXT")
    private String condiciones;

    @Column(nullable = false)
    private LocalDateTime vencimiento;

    @ElementCollection(fetch = FetchType.EAGER) // EAGER or LAZY depending on usage
    @CollectionTable(name = "convenio_firmas", joinColumns = @JoinColumn(name = "convenio_id"))
    @Column(name = "firma")
    private List<String> firmas;

    @Column(name = "on_chain_hash", unique = true)
    private String onChainHash;

    // Relationship with Users through UserConvenio
    @OneToMany(mappedBy = "convenio", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private Collection<UserConvenio> userConvenios = new ArrayList<>();
    
    public enum Status {
        CREATED,
        IN_PROGRESS,
        COMPLETED,
        EXPIRED,
        CANCELLED
    }
}