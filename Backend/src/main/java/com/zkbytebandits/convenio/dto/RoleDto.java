package com.zkbytebandits.convenio.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder
@AllArgsConstructor @NoArgsConstructor
public class RoleDto {
    private Long roleId;
    private String name;
    private String description;
}
