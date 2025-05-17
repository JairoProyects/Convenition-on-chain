package com.zkbytebandits.convenio.service.role.get;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.zkbytebandits.convenio.dto.RoleDto;
import com.zkbytebandits.convenio.mapper.role.RoleMapper;
import com.zkbytebandits.convenio.repository.userRole.UserRoleRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GetRolesForUser {

    private final UserRoleRepository userRoleRepository;

    public List<RoleDto> execute(Long userId) {
        return userRoleRepository.findByUserUserId(userId).stream()
                .map(ur -> RoleMapper.toRoleDto(ur.getRole()))
                .collect(Collectors.toList());
    }
}
