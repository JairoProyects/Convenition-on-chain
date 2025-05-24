package com.zkbytebandits.convenio.dto;
import lombok.*;

@Data
public class UpdateUserRequest {
    private String username;
    private String currentPassword;
    private String newPassword;
    private String confirmNewPassword;
}