package com.zkbytebandits.convenio.repository.contact;

import com.zkbytebandits.convenio.entity.Contact;
import com.zkbytebandits.convenio.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContactRepository extends JpaRepository<Contact, Contact.ContactId> {
    List<Contact> findByUser(User user);
    boolean existsByUserAndContact(User user, User contact);
}
