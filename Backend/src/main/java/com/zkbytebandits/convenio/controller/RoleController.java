package com.zkbytebandits.convenio.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.zkbytebandits.convenio.dto.AssignRoleRequest;
import com.zkbytebandits.convenio.dto.RoleDto;
import com.zkbytebandits.convenio.service.ConvenioService;


@RestController
@RequestMapping("/roles")
public class RoleController {

    @Autowired
    private ConvenioService convenioService;

    @PostMapping
    public ResponseEntity<RoleDto> create(@RequestBody RoleDto request) {
        return ResponseEntity.ok(convenioService.createRole(request));
    }

    @PostMapping("/assign")
    public ResponseEntity<Void> assignRole(@RequestBody AssignRoleRequest request) {
        convenioService.assignRoleToUser(request);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<RoleDto>> getRolesByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(convenioService.getRolesForUser(userId));
    }
}
