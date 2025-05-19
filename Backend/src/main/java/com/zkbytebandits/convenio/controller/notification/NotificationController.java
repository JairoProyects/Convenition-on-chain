package com.zkbytebandits.convenio.controller.notification;

import com.zkbytebandits.convenio.service.NotificationService;
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

    private final NotificationService notificationService;

    @Autowired
    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
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
        return notificationService.createNotification(request.user, request.message, request.type, request.link);
    }

    @PostMapping("/userid")
    public Notification createNotificationWithUserId(@RequestBody CreateNotificationRequest request) {
        return notificationService.createNotification(request.userId, request.message, request.type, request.link);
    }

    @GetMapping("/unread/{userId}")
    public List<Notification> getUnreadNotifications(@PathVariable Long userId) {
        return notificationService.getUnreadNotifications(userId);
    }

    @GetMapping("/all/{userId}")
    public List<Notification> getAllNotificationsForUser(@PathVariable Long userId) {
        return notificationService.getAllNotificationsForUser(userId);
    }

    @PutMapping("/read/{userId}")
    public ResponseEntity<Void> markNotificationsAsRead(@PathVariable Long userId, @RequestBody MarkAsReadRequest request) {
        notificationService.markNotificationsAsRead(userId, request.notificationIds);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/read/all/{userId}")
    public ResponseEntity<Void> markAllNotificationsAsRead(@PathVariable Long userId) {
        notificationService.markAllNotificationsAsRead(userId);
        return ResponseEntity.ok().build();
    }
} 