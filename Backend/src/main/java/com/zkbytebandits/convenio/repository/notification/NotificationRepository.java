package com.zkbytebandits.convenio.repository.notification;


// Import User entity when available
// import com.convenionchain.backend.domain.entity.User;
import com.zkbytebandits.convenio.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    // Find notifications for a specific user, ordered by creation date descending
    List<Notification> findByUserUserIdOrderByCreatedAtDesc(Long userId);

    // Find unread notifications for a specific user
    List<Notification> findByUserUserIdAndIsReadFalseOrderByCreatedAtDesc(Long userId);

    // Count unread notifications for a specific user
    long countByUserUserIdAndIsReadFalse(Long userId);



    // Controller or Repository ?

    // Mark specific notifications as read for a user
    @Modifying
    @Query("UPDATE Notification n SET n.isRead = true WHERE n.user.userId = :userId AND n.id IN :notificationIds")
    void markAsRead(Long userId, List<Long> notificationIds);

    // Mark all notifications as read for a user
    @Modifying
    @Query("UPDATE Notification n SET n.isRead = true WHERE n.user.userId = :userId")
    void markAllAsRead(Long userId);
} 