package com.zkbytebandits.convenio.controller.notification;

import com.zkbytebandits.convenio.service.notification.create.CreateNotificationService;
import com.zkbytebandits.convenio.service.notification.get.GetNotificationService;
import com.zkbytebandits.convenio.service.notification.update.UpdateNotificationService;
import com.zkbytebandits.convenio.entity.Notification;
import com.zkbytebandits.convenio.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final CreateNotificationService createNotificationService;
    private final GetNotificationService getNotificationService;
    private final UpdateNotificationService updateNotificationService;

    @Autowired
    public NotificationController(CreateNotificationService createNotificationService,
                                  GetNotificationService getNotificationService,
                                  UpdateNotificationService updateNotificationService) {
        this.createNotificationService = createNotificationService;
        this.getNotificationService = getNotificationService;
        this.updateNotificationService = updateNotificationService;
    }

    // Inner DTO for createNotification requests
    public static class CreateNotificationRequest {
        public User user;
        public Long userId;
        public String message;
        public String type;
        public String link;
    }
    
    public static class MarkAsReadRequest {
        public List<Long> notificationIds;
    }

    @PostMapping("/user")
    public Notification createNotificationWithUser(@RequestBody CreateNotificationRequest request) {
        return createNotificationService.createNotification(request.user, request.message, request.type, request.link);
    }

    @PostMapping("/userid")
    public Notification createNotificationWithUserId(@RequestBody CreateNotificationRequest request) {
        return createNotificationService.createNotification(request.userId, request.message, request.type, request.link);
    }

    @GetMapping("/unread/{userId}")
    public List<Notification> getUnreadNotifications(@PathVariable Long userId) {
        return getNotificationService.getUnreadNotifications(userId);
    }

    @GetMapping("/all/{userId}")
    public List<Notification> getAllNotificationsForUser(@PathVariable Long userId) {
        return getNotificationService.getAllNotificationsForUser(userId);
    }

    @PutMapping("/read/{userId}")
    public ResponseEntity<Void> markNotificationsAsRead(@PathVariable Long userId, @RequestBody MarkAsReadRequest request) {
        updateNotificationService.markNotificationsAsRead(userId, request.notificationIds);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/read/all/{userId}")
    public ResponseEntity<Void> markAllNotificationsAsRead(@PathVariable Long userId) {
        updateNotificationService.markAllNotificationsAsRead(userId);
        return ResponseEntity.ok().build();
    }
} 