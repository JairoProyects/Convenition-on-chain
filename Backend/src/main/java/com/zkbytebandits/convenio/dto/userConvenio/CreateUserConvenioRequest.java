package com.zkbytebandits.convenio.dto.userConvenio;

import com.zkbytebandits.convenio.entity.UserConvenio.UserConvenioRole;
import com.zkbytebandits.convenio.entity.UserConvenio.UserConvenioStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateUserConvenioRequest {
    
    @NotNull
    private Long userId;
    
    @NotNull
    private Long convenioId;
    
    @NotNull
    private UserConvenioRole role;
    
    @NotNull
    private UserConvenioStatus status;
}
