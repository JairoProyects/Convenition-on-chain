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

        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setStatus(request.getStatus());
        user.setUpdatedAt(LocalDateTime.now());

        return UserMapper.toUserDto(userRepository.save(user));
    }
}
