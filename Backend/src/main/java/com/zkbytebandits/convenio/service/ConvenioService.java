package com.zkbytebandits.convenio.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;

import com.zkbytebandits.convenio.dto.AssignRoleRequest;
import com.zkbytebandits.convenio.dto.CreateUserRequest;
import com.zkbytebandits.convenio.dto.RoleDto;
import com.zkbytebandits.convenio.dto.UpdateUserRequest;
import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.entity.Role;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.User.Status;
import com.zkbytebandits.convenio.entity.UserRole;
import com.zkbytebandits.convenio.repository.RoleRepository;
import com.zkbytebandits.convenio.repository.UserRepository;
import com.zkbytebandits.convenio.repository.UserRoleRepository;
import org.springframework.stereotype.Service;

@Service
public class ConvenioService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;
    
    @Autowired
    private UserRoleRepository userRoleRepository;

    // ████████████████████████████████████████████████████████████████████
    // █                       👤 USER MODULE                              █
    // ████████████████████████████████████████████████████████████████████

    public UserDto createUser(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email ya registrado.");
        }

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username ya en uso.");
        }

        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .passwordHash(BCrypt.hashpw(request.getPassword(), BCrypt.gensalt()))
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .status(Status.ACTIVO)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return toUserDto(userRepository.save(user));
    }

    public List<UserDto> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::toUserDto)
                .collect(Collectors.toList());
    }

    public UserDto getUserById(Long id) {
        return userRepository.findById(id)
                .map(this::toUserDto)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    public UserDto updateUser(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setStatus(request.getStatus());
        user.setUpdatedAt(LocalDateTime.now());

        return toUserDto(userRepository.save(user));
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    private UserDto toUserDto(User u) {
        return UserDto.builder()
                .userId(u.getUserId())
                .username(u.getUsername())
                .email(u.getEmail())
                .firstName(u.getFirstName())
                .lastName(u.getLastName())
                .status(u.getStatus())
                .build();
    }

    // ████████████████████████████████████████████████████████████████████
    // █                       🛡️ ROLE MODULE                              █
    // ████████████████████████████████████████████████████████████████████

    public RoleDto createRole(RoleDto request) {
        if (roleRepository.findByName(request.getName()).isPresent()) {
            throw new IllegalArgumentException("Rol ya existe");
        }

        Role role = Role.builder()
                .name(request.getName())
                .description(request.getDescription())
                .build();

        return toRoleDto(roleRepository.save(role));
    }

    public void assignRoleToUser(AssignRoleRequest request) {
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

    public List<RoleDto> getRolesForUser(Long userId) {
        return userRoleRepository.findByUserUserId(userId).stream()
                .map(ur -> toRoleDto(ur.getRole()))
                .collect(Collectors.toList());
    }

    private RoleDto toRoleDto(Role r) {
        return RoleDto.builder()
                .roleId(r.getRoleId())
                .name(r.getName())
                .description(r.getDescription())
                .build();
    }
}