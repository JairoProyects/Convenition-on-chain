package com.zkbytebandits.convenio.service.role.assign;

import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.dto.AssignRoleRequest;
import com.zkbytebandits.convenio.entity.*;
import com.zkbytebandits.convenio.repository.role.RoleRepository;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.repository.userRole.UserRoleRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AssignRoleToUser {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;

    public void execute(AssignRoleRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Role role = roleRepository.findById(request.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        UserRole.UserRoleId id = new UserRole.UserRoleId();
        id.setUserId(user.getUserId());
        id.setRoleId(role.getRoleId());

        if (userRoleRepository.existsById(id)) {
            throw new IllegalArgumentException("Este rol ya fue asignado");
        }

        UserRole userRole = UserRole.builder()
                .id(id)
                .user(user)
                .role(role)
                .assignedAt(LocalDateTime.now())
                .build();

        userRoleRepository.save(userRole);
    }
}
