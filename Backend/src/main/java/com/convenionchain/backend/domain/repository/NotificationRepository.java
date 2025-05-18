package com.zkbytebandits.convenio.repository;

import com.zkbytebandits.convenio.entity.Notification;
// Import User entity when available
// import com.convenionchain.backend.domain.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    // Find notifications for a specific user, ordered by creation date descending
    List<Notification> findByUserIdOrderByCreatedAtDesc(Long userId);

    // Find unread notifications for a specific user
    List<Notification> findByUserIdAndIsReadFalseOrderByCreatedAtDesc(Long userId);

    // Count unread notifications for a specific user
    long countByUserIdAndIsReadFalse(Long userId);



    // Controller or Repository ?

    // Mark specific notifications as read for a user
    @Modifying
    @Query("UPDATE Notification n SET n.isRead = true WHERE n.user.id = :userId AND n.id IN :notificationIds")
    void markAsRead(Long userId, List<Long> notificationIds);

    // Mark all notifications as read for a user
    @Modifying
    @Query("UPDATE Notification n SET n.isRead = true WHERE n.user.id = :userId")
    void markAllAsRead(Long userId);
} 