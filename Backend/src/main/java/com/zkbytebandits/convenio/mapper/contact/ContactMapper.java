package com.zkbytebandits.convenio.mapper.contact;

import com.zkbytebandits.convenio.dto.contact.ContactDTO;
import com.zkbytebandits.convenio.dto.contact.UserDTO;
import com.zkbytebandits.convenio.entity.Contact;
import com.zkbytebandits.convenio.entity.User;
import org.springframework.stereotype.Component;

@Component
public class ContactMapper {

    public ContactDTO toContactDTO(Contact contact) {
        if (contact == null) {
            return null;
        }
        return ContactDTO.builder()
                .id(contact.getUser().getUserId()) // Use the user's ID directly
                .user(toUserDTO(contact.getUser()))
                .contact(toUserDTO(contact.getContact()))
                .createdAt(contact.getCreatedAt().toString())
                .build();
    }

    public Contact toContactEntity(ContactDTO contactDTO) {
        if (contactDTO == null) {
            return null;
        }
        Contact contact = new Contact();
        
        // Set the user objects first
        User user = new User();
        user.setUserId(contactDTO.getId());
        contact.setUser(user);
        
        User contactUser = new User();
        contactUser.setUserId(contactDTO.getContact().getId());
        contact.setContact(contactUser);
        
        // No need to manually set the composite ID
        // JPA will automatically create it from the @Id annotated fields
        // The @IdClass will map the User entities to the appropriate ID fields
        
        // Set the creation time
        contact.setCreatedAt(contactDTO.getCreatedAt() != null ? 
            java.time.LocalDateTime.parse(contactDTO.getCreatedAt()) : null);
            
        return contact;
    }

    public UserDTO toUserDTO(User user) {
        if (user == null) {
            return null;
        }
        return UserDTO.builder()
                .id(user.getUserId())
                .username(user.getUsername())
                .email(user.getEmail())
                .build();
    }
}
