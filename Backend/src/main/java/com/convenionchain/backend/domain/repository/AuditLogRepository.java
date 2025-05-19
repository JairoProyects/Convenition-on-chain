package com.convenionchain.backend.domain.repository;

import com.convenionchain.backend.domain.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    // Find logs by actor
    Page<AuditLog> findByActor(String actor, Pageable pageable);

    // Find logs by action
    Page<AuditLog> findByAction(String action, Pageable pageable);

    // Find logs by resource type and ID
    Page<AuditLog> findByResourceTypeAndResourceId(String resourceType, String resourceId, Pageable pageable);

    // Find logs within a specific time range
    Page<AuditLog> findByTimestampBetween(LocalDateTime startTime, LocalDateTime endTime, Pageable pageable);

    // Find logs by actor and action
    Page<AuditLog> findByActorAndAction(String actor, String action, Pageable pageable);

} 