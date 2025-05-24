package com.zkbytebandits.convenio.service.contact.add;

import com.zkbytebandits.convenio.dto.contact.ContactDTO;
import com.zkbytebandits.convenio.dto.contact.UserDTO;
import com.zkbytebandits.convenio.entity.Contact;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.contact.ContactRepository;
import com.zkbytebandits.convenio.mapper.contact.ContactMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AddContact {

    @Autowired
    private ContactRepository contactRepository;

    @Autowired
    private ContactMapper contactMapper;

    @Transactional
    public ContactDTO execute(User user, User contact) {
        if (contactRepository.existsByUserAndContact(user, contact)) {
            throw new RuntimeException("Contact already exists");
        }
        Contact newContact = new Contact();
        newContact.setUser(user);
        newContact.setContact(contact);
        Contact savedContact = contactRepository.save(newContact);
        return contactMapper.toContactDTO(savedContact);
    }
}
