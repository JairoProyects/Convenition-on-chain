package com.zkbytebandits.convenio.service.user.delete;

import org.springframework.stereotype.Service;
import com.zkbytebandits.convenio.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeleteUser {

    private final UserRepository userRepository;

    public void execute(Long id) {
        userRepository.deleteById(id);
    }
}

