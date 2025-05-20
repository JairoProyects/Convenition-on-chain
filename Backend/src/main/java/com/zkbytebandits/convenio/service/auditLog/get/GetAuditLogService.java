package com.zkbytebandits.convenio.service.auditLog.get;

import com.zkbytebandits.convenio.entity.AuditLog;
import com.zkbytebandits.convenio.repository.auditLog.AuditLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class GetAuditLogService {

    private final AuditLogRepository auditLogRepository;

    @Autowired
    public GetAuditLogService(AuditLogRepository auditLogRepository) {
        this.auditLogRepository = auditLogRepository;
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> findByAction(String action, Pageable pageable) {
        return auditLogRepository.findByAction(action, pageable);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> findByResourceTypeAndResourceId(String resourceType, String resourceId, Pageable pageable) {
        return auditLogRepository.findByResourceTypeAndResourceId(resourceType, resourceId, pageable);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> findByTimestampBetween(LocalDateTime startTime, LocalDateTime endTime, Pageable pageable) {
        return auditLogRepository.findByTimestampBetween(startTime, endTime, pageable);
    }
} 