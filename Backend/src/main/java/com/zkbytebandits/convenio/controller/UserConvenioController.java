package com.zkbytebandits.convenio.controller;

import com.zkbytebandits.convenio.dto.userConvenio.CreateUserConvenioRequest;
import com.zkbytebandits.convenio.dto.userConvenio.UpdateUserConvenioRequest;
import com.zkbytebandits.convenio.dto.userConvenio.UserConvenioDto;
import com.zkbytebandits.convenio.service.userConvenio.create.CreateUserConvenio;
import com.zkbytebandits.convenio.service.userConvenio.delete.DeleteUserConvenio;
import com.zkbytebandits.convenio.service.userConvenio.get.GetUserConveniosByConvenio;
import com.zkbytebandits.convenio.service.userConvenio.get.GetUserConveniosByUser;
import com.zkbytebandits.convenio.service.userConvenio.update.UpdateUserConvenio;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user-convenios")
@RequiredArgsConstructor
public class UserConvenioController {

    private final CreateUserConvenio createUserConvenio;
    private final GetUserConveniosByUser getUserConveniosByUser;
    private final GetUserConveniosByConvenio getUserConveniosByConvenio;
    private final UpdateUserConvenio updateUserConvenio;
    private final DeleteUserConvenio deleteUserConvenio;

    @PostMapping
    public ResponseEntity<UserConvenioDto> create(@RequestBody CreateUserConvenioRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(createUserConvenio.execute(request));
    }

    @GetMapping("/by-user/{userId}")
    public ResponseEntity<List<UserConvenioDto>> getByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(getUserConveniosByUser.execute(userId));
    }

    @GetMapping("/by-convenio/{convenioId}")
    public ResponseEntity<List<UserConvenioDto>> getByConvenio(@PathVariable Long convenioId) {
        return ResponseEntity.ok(getUserConveniosByConvenio.execute(convenioId));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserConvenioDto> update(@PathVariable Long id, @RequestBody UpdateUserConvenioRequest request) {
        return ResponseEntity.ok(updateUserConvenio.execute(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        deleteUserConvenio.execute(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/user/{userId}/convenio/{convenioId}")
    public ResponseEntity<Void> deleteByUserAndConvenio(@PathVariable Long userId, @PathVariable Long convenioId) {
        deleteUserConvenio.executeByUserAndConvenio(userId, convenioId);
        return ResponseEntity.noContent().build();
    }
}
