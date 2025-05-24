package com.zkbytebandits.convenio.service.contact.get;

import com.zkbytebandits.convenio.dto.contact.ContactDTO;
import com.zkbytebandits.convenio.entity.Contact;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.contact.ContactRepository;
import com.zkbytebandits.convenio.mapper.contact.ContactMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class GetContacts {

    @Autowired
    private ContactRepository contactRepository;

    @Autowired
    private ContactMapper contactMapper;

    public List<ContactDTO> execute(User user) {
        List<Contact> contacts = contactRepository.findByUser(user);
        return contacts.stream()
                .map(contactMapper::toContactDTO)
                .collect(Collectors.toList());
    }
}
