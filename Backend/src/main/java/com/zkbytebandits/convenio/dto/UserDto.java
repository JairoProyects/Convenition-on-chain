package com.zkbytebandits.convenio.dto;
import com.zkbytebandits.convenio.entity.User.Status;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDto {
    private Long userId;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private Status status;
}
