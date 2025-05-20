package com.zkbytebandits.convenio.service.notification.get;

import com.zkbytebandits.convenio.entity.Notification;
import com.zkbytebandits.convenio.repository.notification.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GetNotificationService {

    private final NotificationRepository notificationRepository;

    @Autowired
    public GetNotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    @Transactional(readOnly = true)
    public List<Notification> getUnreadNotifications(Long userId) {
        return notificationRepository.findByUserUserIdAndIsReadFalseOrderByCreatedAtDesc(userId);
    }

    @Transactional(readOnly = true)
    public List<Notification> getAllNotificationsForUser(Long userId) {
        return notificationRepository.findByUserUserIdOrderByCreatedAtDesc(userId);
    }
} 