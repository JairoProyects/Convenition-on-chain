package com.zkbytebandits.convenio.mapper.role;

import com.zkbytebandits.convenio.dto.RoleDto;
import com.zkbytebandits.convenio.entity.Role;

public class RoleMapper {

    private RoleMapper() {}

    public static RoleDto toRoleDto(Role role) {
        if (role == null) return null;

        return RoleDto.builder()
                .roleId(role.getRoleId())
                .name(role.getName())
                .description(role.getDescription())
                .build();
    }
}