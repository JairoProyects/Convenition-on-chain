package com.zkbytebandits.convenio.mapper.user;

import com.zkbytebandits.convenio.dto.*;
import com.zkbytebandits.convenio.entity.*;

public class UserMapper {
    private UserMapper() {
        // Private constructor to prevent instantiation
    }

    public static UserDto toUserDto(User user) {
        if (user == null) {
            return null;
        }

        return UserDto.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .status(user.getStatus())
                .profileImageUrl(user.getProfileImageUrl())
                .build();
    }
}
