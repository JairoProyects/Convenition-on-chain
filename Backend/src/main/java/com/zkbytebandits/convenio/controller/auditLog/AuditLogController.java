package com.zkbytebandits.convenio.controller.auditLog;

import com.zkbytebandits.convenio.service.auditLog.create.CreateAuditLogService;
import com.zkbytebandits.convenio.service.auditLog.get.GetAuditLogService;
import com.zkbytebandits.convenio.entity.AuditLog;
import com.zkbytebandits.convenio.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/auditlogs")
public class AuditLogController {

    private final CreateAuditLogService createAuditLogService;
    private final GetAuditLogService getAuditLogService;

    @Autowired
    public AuditLogController(CreateAuditLogService createAuditLogService, GetAuditLogService getAuditLogService) {
        this.createAuditLogService = createAuditLogService;
        this.getAuditLogService = getAuditLogService;
    }

    // DTO for recordEvent requests
    public static class RecordEventRequest {
        public User user;
        public String action;
        public String resourceType;
        public String resourceId;
        public String details; // Optional
    }

    @PostMapping("/record")
    public ResponseEntity<Void> recordEvent(@RequestBody RecordEventRequest request) {
        if (request.details != null) {
            createAuditLogService.recordEvent(request.user, request.action, request.resourceType, request.resourceId, request.details);
        } else {
            createAuditLogService.recordEvent(request.user, request.action, request.resourceType, request.resourceId);
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/action")
    public Page<AuditLog> findByAction(@RequestParam String action, Pageable pageable) {
        return getAuditLogService.findByAction(action, pageable);
    }

    @GetMapping("/resource")
    public Page<AuditLog> findByResourceTypeAndResourceId(@RequestParam String resourceType, @RequestParam String resourceId, Pageable pageable) {
        return getAuditLogService.findByResourceTypeAndResourceId(resourceType, resourceId, pageable);
    }

    @GetMapping("/timestamp")
    public Page<AuditLog> findByTimestampBetween(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime,
            Pageable pageable) {
        return getAuditLogService.findByTimestampBetween(startTime, endTime, pageable);
    }
} 