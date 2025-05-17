package com.zkbytebandits.convenio.service.user.get;

import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.dto.*;
import com.zkbytebandits.convenio.mapper.user.*;
import com.zkbytebandits.convenio.repository.*;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GetAllUsers {

    private final UserRepository userRepository;

    public List<UserDto> execute() {
        return userRepository.findAll().stream()
                .map(UserMapper::toUserDto)
                .collect(Collectors.toList());
    }
} 
