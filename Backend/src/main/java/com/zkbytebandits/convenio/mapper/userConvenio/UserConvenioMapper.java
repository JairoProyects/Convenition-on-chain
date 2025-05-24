package com.zkbytebandits.convenio.mapper.userConvenio;

import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.dto.convenio.ConvenioDTO;
import com.zkbytebandits.convenio.dto.userConvenio.UserConvenioDto;
import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.UserConvenio;
import com.zkbytebandits.convenio.mapper.convenio.ConvenioMapper;
import com.zkbytebandits.convenio.mapper.user.UserMapper;
import org.springframework.stereotype.Component;

@Component
public class UserConvenioMapper {

    private final ConvenioMapper convenioMapper;

    public UserConvenioMapper(ConvenioMapper convenioMapper) {
        this.convenioMapper = convenioMapper;
    }

    public UserConvenioDto toDto(UserConvenio userConvenio) {
        if (userConvenio == null) {
            return null;
        }

        User user = userConvenio.getUser();
        Convenio convenio = userConvenio.getConvenio();

        UserDto userDto = UserMapper.toUserDto(user);
        ConvenioDTO convenioResponse = convenioMapper.toDto(convenio);

        return UserConvenioDto.builder()
                .id(userConvenio.getId())
                .user(userDto)
//                .convenio(convenioResponse)
                .assignedAt(userConvenio.getAssignedAt())
                .role(userConvenio.getRole())
                .status(userConvenio.getStatus())
                .build();
    }
}
