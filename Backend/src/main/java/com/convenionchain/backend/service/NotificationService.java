package com.zkbytebandits.convenio.service;

import com.zkbytebandits.convenio.entity.Notification;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.NotificationRepository;
// Assuming UserRepository will be in com.zkbytebandits.convenio.repository.user.UserRepository
// import com.zkbytebandits.convenio.repository.user.UserRepository; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    // private final UserRepository userRepository; // For fetching User entities if needed

    @Autowired
    public NotificationService(NotificationRepository notificationRepository) { // , UserRepository userRepository) {
        this.notificationRepository = notificationRepository;
        // this.userRepository = userRepository;
    }

    @Transactional
    public Notification createNotification(User user, String message, String type, String link) {
        Notification notification = Notification.builder()
                .user(user)
                .message(message)
                .type(type)
                .link(link)
                .isRead(false)
                .build();
        return notificationRepository.save(notification);
    }

    // Overloaded method if you have userId instead of User object
    @Transactional
    public Notification createNotification(Long userId, String message, String type, String link) {
        Notification notification = Notification.builder()
                .message(message)
                .type(type)
                .link(link)
                .isRead(false)
                .build();
        
        if (userId != null) {
            System.err.println("Warning: Creating notification with userId. User link will be missing as User entity is not fetched here. Consider fetching User by ID and setting it.");
        }
        return notificationRepository.save(notification);
    }

    @Transactional(readOnly = true)
    public List<Notification> getUnreadNotifications(Long userId) {
        // This query in NotificationRepository uses n.user.id, which should work if User has an 'id' field named 'userId'
        return notificationRepository.findByUserIdAndIsReadFalseOrderByCreatedAtDesc(userId);
    }

    @Transactional(readOnly = true)
    public List<Notification> getAllNotificationsForUser(Long userId) {
        return notificationRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Transactional
    public void markNotificationsAsRead(Long userId, List<Long> notificationIds) {
        if (notificationIds == null || notificationIds.isEmpty()) {
            return; 
        }
        notificationRepository.markAsRead(userId, notificationIds);
    }

    @Transactional
    public void markAllNotificationsAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId);
    }
} 