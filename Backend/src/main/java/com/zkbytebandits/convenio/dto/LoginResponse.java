package com.zkbytebandits.convenio.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private Long userId;
    private String username;
    private String email;
    private String token;  // This can be used for JWT token if authentication is implemented
    private String firstName;
    private String lastName;
    private String profileImageUrl;
}
