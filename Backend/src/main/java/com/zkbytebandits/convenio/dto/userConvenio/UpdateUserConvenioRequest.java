package com.zkbytebandits.convenio.dto.userConvenio;

import com.zkbytebandits.convenio.entity.UserConvenio.UserConvenioRole;
import com.zkbytebandits.convenio.entity.UserConvenio.UserConvenioStatus;
import lombok.Data;

@Data
public class UpdateUserConvenioRequest {
    
    private UserConvenioRole role;
    
    private UserConvenioStatus status;
}
