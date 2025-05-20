package com.zkbytebandits.convenio.service.notification.create;

import com.zkbytebandits.convenio.entity.Notification;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.notification.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CreateNotificationService {

    private final NotificationRepository notificationRepository;

    @Autowired
    public CreateNotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
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
        // It's generally better to fetch the User entity here if `userId` is meant to link to a User.
        // For this refactor, keeping original logic.
        User userReference = null; // Or fetch user by ID: userRepository.findById(userId).orElse(null);
        if (userId != null) {
            // If you have a UserRepository, you would fetch the user here.
            // For now, we are creating a notification that might not be directly linked if User object is not passed
            // or if the User field in Notification entity is nullable or handled differently.
            // The original service printed a warning, which is good practice.
            System.err.println("Warning: Creating notification with userId. User object is not fetched here. Ensure User field in Notification is handled if it's expected to be populated.");
        }

        Notification notification = Notification.builder()
                // .user(userReference) // Explicitly set user if fetched or keep as original
                .message(message)
                .type(type)
                .link(link)
                .isRead(false)
                .build();
        // If your Notification entity has a direct Long userId field that needs to be set, do it here.
        // Otherwise, if it expects a User entity, the above .user(userReference) is the way.
        // The original code didn't explicitly set a user when only userId was passed, relying on the builder or entity structure.

        return notificationRepository.save(notification);
    }
} 