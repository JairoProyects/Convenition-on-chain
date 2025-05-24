package com.zkbytebandits.convenio.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "contacts")
@IdClass(Contact.ContactId.class)
public class Contact {
    @Id
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Id
    @ManyToOne
    @JoinColumn(name = "contact_id")
    private User contact;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    @Data
    public static class ContactId implements java.io.Serializable {
        private Long user;
        private Long contact;
    }
}
