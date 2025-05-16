package com.zkbytebandits.convenio.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.crypto.bcrypt.BCrypt;

import com.zkbytebandits.convenio.dto.CreateUserRequest;
import com.zkbytebandits.convenio.dto.UpdateUserRequest;
import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.User.Status;
import com.zkbytebandits.convenio.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ConvenioService {
    private final UserRepository userRepository;

    // ──────── USER MODULE ────────

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
}
