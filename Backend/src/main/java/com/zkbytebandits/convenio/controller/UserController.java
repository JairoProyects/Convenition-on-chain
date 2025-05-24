package com.zkbytebandits.convenio.controller;

import com.zkbytebandits.convenio.dto.*;
import com.zkbytebandits.convenio.service.user.create.CreateUser;
import com.zkbytebandits.convenio.service.user.get.GetAllUsers;
import com.zkbytebandits.convenio.service.user.get.GetUserById;
import com.zkbytebandits.convenio.service.user.update.UpdateUser;
import com.zkbytebandits.convenio.service.user.delete.DeleteUser;
import com.zkbytebandits.convenio.service.user.login.LoginUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final CreateUser createUser;
    private final GetAllUsers getAllUsers;
    private final GetUserById getUserById;
    private final UpdateUser updateUser;
    private final DeleteUser deleteUser;
    private final LoginUser loginUser;


    @PostMapping(value = "/register", consumes = {"multipart/form-data"})
    public ResponseEntity<UserDto> create(
            @ModelAttribute CreateUserRequest request) {
        return ResponseEntity.ok(createUser.execute(request));
    }

    @GetMapping
    public ResponseEntity<List<UserDto>> getAll() {
        return ResponseEntity.ok(getAllUsers.execute());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(getUserById.execute(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserDto> update(@PathVariable Long id, @RequestBody UpdateUserRequest request) {
        return ResponseEntity.ok(updateUser.execute(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        deleteUser.execute(id);
        return ResponseEntity.noContent().build();
    }
    
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(loginUser.execute(request));
    }
}