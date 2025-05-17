package com.zkbytebandits.convenio.repository.userRole;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.zkbytebandits.convenio.entity.UserRole;


public interface UserRoleRepository extends JpaRepository<UserRole, UserRole.UserRoleId> {
    List<UserRole> findByUserUserId(Long userId);
}
