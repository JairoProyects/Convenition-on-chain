package com.zkbytebandits.convenio.service.user.create;

import java.time.LocalDateTime;

//import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.dto.*;
import com.zkbytebandits.convenio.entity.*;
import com.zkbytebandits.convenio.entity.User.Status;
import com.zkbytebandits.convenio.mapper.user.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CreateUser {

    private final UserRepository userRepository;

    public UserDto execute(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email ya registrado.");
        }

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username ya en uso.");
        }

        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                //.passwordHash(BCrypt.hashpw(request.getPassword(), BCrypt.gensalt()))
                .passwordHash(request.getPassword()) // TODO: Hash the password
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .status(Status.ACTIVO)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return UserMapper.toUserDto(userRepository.save(user));
    }
} 
