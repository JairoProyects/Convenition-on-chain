package com.zkbytebandits.convenio.service.user.update;

import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.dto.UpdateUserRequest;
import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.mapper.user.UserMapper;
import com.zkbytebandits.convenio.repository.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UpdateUser {

    private final UserRepository userRepository;

    public UserDto execute(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        // Validar contraseña actual
        if (!user.getPasswordHash().equals(request.getCurrentPassword())) {
            throw new RuntimeException("La contraseña actual no es válida");
        }

        // Validar coincidencia de nueva contraseña
        if (!request.getNewPassword().equals(request.getConfirmNewPassword())) {
            throw new RuntimeException("La nueva contraseña y su confirmación no coinciden");
        }

        // Actualizar nombre de usuario y contraseña
        user.setUsername(request.getUsername());
        if (request.getNewPassword() != null && !request.getNewPassword().isEmpty()) {
            user.setPasswordHash(request.getNewPassword()); // Agrega hash aquí si usas BCrypt
        }

        user.setUpdatedAt(LocalDateTime.now());

        return UserMapper.toUserDto(userRepository.save(user));
    }
}
