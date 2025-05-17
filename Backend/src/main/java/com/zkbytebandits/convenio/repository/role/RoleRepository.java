package com.zkbytebandits.convenio.repository.role;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.zkbytebandits.convenio.entity.Role;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(String name);
}
