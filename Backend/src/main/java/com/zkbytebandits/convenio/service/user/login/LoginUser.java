package com.zkbytebandits.convenio.service.user.login;

import com.zkbytebandits.convenio.dto.LoginRequest;
import com.zkbytebandits.convenio.dto.LoginResponse;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LoginUser {

    private final UserRepository userRepository;

    public LoginResponse execute(LoginRequest request) {
        // Find user by email
        Optional<User> userOptional = userRepository.findByEmail(request.getEmail());
        
        if (userOptional.isEmpty()) {
            throw new RuntimeException("Invalid credentials");
        }
        
        User user = userOptional.get();
        
        // Verify password (basic check - in a real app you would use proper password hashing)
        // This simple check assumes the password is stored as a hash already
        if (!user.getPasswordHash().equals(request.getClave())) {
            throw new RuntimeException("Invalid credentials");
        }
        
        // Create and return login response
        return LoginResponse.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .profileImageUrl(user.getProfileImageUrl())
                .token("generated-token") // In a real application, generate a JWT token here
                .build();
    }
}
