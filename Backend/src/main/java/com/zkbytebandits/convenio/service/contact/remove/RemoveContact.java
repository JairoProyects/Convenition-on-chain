package com.zkbytebandits.convenio.service.contact.remove;

import com.zkbytebandits.convenio.entity.Contact;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.contact.ContactRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RemoveContact {

    @Autowired
    private ContactRepository contactRepository;

    @Transactional
    public void execute(User user, User contact) {
        Contact.ContactId id = new Contact.ContactId();
        id.setUser(user.getUserId());
        id.setContact(contact.getUserId());
        contactRepository.deleteById(id);
    }
}
