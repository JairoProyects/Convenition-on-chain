package com.zkbytebandits.convenio.dto.userConvenio;

import com.zkbytebandits.convenio.dto.UserDto;
import com.zkbytebandits.convenio.entity.UserConvenio.UserConvenioRole;
import com.zkbytebandits.convenio.entity.UserConvenio.UserConvenioStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserConvenioDto {
    
    private Long id;
    private UserDto user;
//    private  convenio;
    private LocalDateTime assignedAt;
    private UserConvenioRole role;
    private UserConvenioStatus status;
}
