package com.zkbytebandits.convenio.service.user.create;

import java.io.IOException;
import java.time.LocalDateTime;

//import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.dto.*;
import com.zkbytebandits.convenio.entity.*;
import com.zkbytebandits.convenio.entity.User.Status;
import com.zkbytebandits.convenio.mapper.user.UserMapper;
import com.zkbytebandits.convenio.service.file.FileStorageService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CreateUser {

    private final UserRepository userRepository;
    private final FileStorageService fileStorageService;

    @Transactional
    public UserDto execute(CreateUserRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email ya registrado.");
        }

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username ya en uso.");
        }

        // First create the user without the image
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

        // Save the user to get the ID
        User savedUser = userRepository.save(user);
        
        // Process the image if provided
        if (request.getImage() != null && !request.getImage().isEmpty()) {
            try {
                // Upload the image using the user's ID
                String imageUrl = fileStorageService.storeFile(request.getImage());
                
                // Update the user with the image URL
                savedUser.setProfileImageUrl(imageUrl);
                savedUser = userRepository.save(savedUser);
            } catch (IOException e) {
                // Log the error but continue with user creation
                System.err.println("Error uploading profile image: " + e.getMessage());
            }
        }
        
        return UserMapper.toUserDto(savedUser);
    }
} 
