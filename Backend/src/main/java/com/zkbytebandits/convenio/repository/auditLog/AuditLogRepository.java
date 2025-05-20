package com.zkbytebandits.convenio.repository.auditLog;

import com.zkbytebandits.convenio.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    // Find logs by action
    Page<AuditLog> findByAction(String action, Pageable pageable);

    // Find logs by resource type and ID
    Page<AuditLog> findByResourceTypeAndResourceId(String resourceType, String resourceId, Pageable pageable);

    // Find logs within a specific time range
    Page<AuditLog> findByTimestampBetween(LocalDateTime startTime, LocalDateTime endTime, Pageable pageable);

} 