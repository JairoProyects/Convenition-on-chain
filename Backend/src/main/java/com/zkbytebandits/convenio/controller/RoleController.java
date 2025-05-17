package com.zkbytebandits.convenio.controller;

import java.util.List;
import com.zkbytebandits.convenio.dto.AssignRoleRequest;
import com.zkbytebandits.convenio.dto.RoleDto;
import com.zkbytebandits.convenio.service.role.assign.AssignRoleToUser;
import com.zkbytebandits.convenio.service.role.create.CreateRole;
import com.zkbytebandits.convenio.service.role.get.GetRolesForUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/roles")
@RequiredArgsConstructor
public class RoleController {

    private final CreateRole createRole;
    private final AssignRoleToUser assignRoleToUser;
    private final GetRolesForUser getRolesForUser;

    @PostMapping
    public ResponseEntity<RoleDto> create(@RequestBody RoleDto request) {
        return ResponseEntity.ok(createRole.execute(request));
    }

    @PostMapping("/assign")
    public ResponseEntity<Void> assignRole(@RequestBody AssignRoleRequest request) {
        assignRoleToUser.execute(request);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<RoleDto>> getRolesByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(getRolesForUser.execute(userId));
    }
}