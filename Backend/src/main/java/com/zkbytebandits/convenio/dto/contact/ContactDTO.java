package com.zkbytebandits.convenio.dto.contact;

import lombok.Data;
import lombok.Builder;

@Data
@Builder
public class ContactDTO {
    private Long id;
    private UserDTO user;
    private UserDTO contact;
    private String createdAt;
}
