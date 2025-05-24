package com.zkbytebandits.convenio.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "convenios")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "userConvenios"}) 
public class Convenio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private Status status;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime timestamp;

    @Column(nullable = false, precision = 19, scale = 4)
    private BigDecimal monto;

    @Column(nullable = false, length = 10)
    private String moneda;

    @Column(nullable = false)
    private String descripcion;


    @Column(nullable = false)
    private String condiciones;

    @Column(nullable = false)
    private LocalDateTime vencimiento;

    @Column(name = "on_chain_hash", unique = true)
    private String onChainHash;

    public enum Status {
        CREATED,
        IN_PROGRESS,
        COMPLETED,
        EXPIRED,
        CANCELLED
    }
}