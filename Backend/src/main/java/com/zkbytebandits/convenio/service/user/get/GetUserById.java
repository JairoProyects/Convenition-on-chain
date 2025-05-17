package com.zkbytebandits.convenio.service.user.get;

import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.mapper.user.UserMapper;
import com.zkbytebandits.convenio.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GetUserById {

    private final UserRepository userRepository;

    public UserDto execute(Long id) {
        return userRepository.findById(id)
                .map(UserMapper::toUserDto)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }
}
