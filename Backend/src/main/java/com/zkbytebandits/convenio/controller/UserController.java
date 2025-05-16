package com.zkbytebandits.convenio.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.zkbytebandits.convenio.dto.*;
import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.service.ConvenioService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/users")
public class UserController {

    private final ConvenioService convenioService;

    @PostMapping
    public ResponseEntity<UserDto> create(@Valid @RequestBody CreateUserRequest request) {
        return ResponseEntity.ok(convenioService.createUser(request));
    }

    @GetMapping
    public ResponseEntity<List<UserDto>> getAll() {
        return ResponseEntity.ok(convenioService.getAllUsers());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(convenioService.getUserById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserDto> update(@PathVariable Long id, @RequestBody UpdateUserRequest request) {
        return ResponseEntity.ok(convenioService.updateUser(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        convenioService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}