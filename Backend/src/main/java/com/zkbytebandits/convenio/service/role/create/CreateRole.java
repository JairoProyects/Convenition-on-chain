package com.zkbytebandits.convenio.service.role.create;

import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.RoleDto;
import com.zkbytebandits.convenio.entity.Role;
import com.zkbytebandits.convenio.repository.RoleRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CreateRole {

    private final RoleRepository roleRepository;

    public RoleDto execute(RoleDto request) {
        if (roleRepository.findByName(request.getName()).isPresent()) {
            throw new IllegalArgumentException("Rol ya existe");
        }

        Role role = Role.builder()
                .name(request.getName())
                .description(request.getDescription())
                .build();

        return com.zkbytebandits.convenio.mapper.role.RoleMapper.toRoleDto(roleRepository.save(role));
    }
}