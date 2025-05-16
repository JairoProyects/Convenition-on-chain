package com.zkbytebandits.convenio.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
public class CreateUserRequest {
    
    @NotBlank
    private String username;

    @Email
    private String email;

    @NotBlank
    private String password;

    private String firstName;
    private String lastName;
}