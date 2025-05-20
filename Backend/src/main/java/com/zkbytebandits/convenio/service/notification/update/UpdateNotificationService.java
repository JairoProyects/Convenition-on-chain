package com.zkbytebandits.convenio.service.notification.update;

import com.zkbytebandits.convenio.repository.notification.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UpdateNotificationService {

    private final NotificationRepository notificationRepository;

    @Autowired
    public UpdateNotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
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