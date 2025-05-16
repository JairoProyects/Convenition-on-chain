package com.zkbytebandits.convenio.dto;
import com.zkbytebandits.convenio.entity.User.Status;
import lombok.*;

@Data
public class UpdateUserRequest {
    private String firstName;
    private String lastName;
    private Status status;
}
