package com.zkbytebandits.convenio.controller.contact;

import com.zkbytebandits.convenio.dto.contact.ContactDTO;
import com.zkbytebandits.convenio.dto.contact.UserDTO;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.service.contact.add.AddContact;
import com.zkbytebandits.convenio.service.contact.get.GetContacts;
import com.zkbytebandits.convenio.service.contact.remove.RemoveContact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contacts")
public class ContactController {

    @Autowired
    private AddContact addContactService;

    @Autowired
    private GetContacts getContactsService;

    @Autowired
    private RemoveContact removeContactService;

    @GetMapping("/my-contacts")
    public ResponseEntity<List<ContactDTO>> getMyContacts(@RequestParam Long userId) {
        User user = new User();
        user.setUserId(userId);
        List<ContactDTO> contacts = getContactsService.execute(user);
        return ResponseEntity.ok(contacts);
    }

    @PostMapping("/add")
    public ResponseEntity<ContactDTO> addContact(
            @RequestParam Long userId,
            @RequestParam Long contactId) {
        User user = new User();
        user.setUserId(userId);
        User contact = new User();
        contact.setUserId(contactId);
        ContactDTO newContact = addContactService.execute(user, contact);
        return ResponseEntity.ok(newContact);
    }

    @DeleteMapping("/remove")
    public ResponseEntity<Void> removeContact(
            @RequestParam Long userId,
            @RequestParam Long contactId) {
        User user = new User();
        user.setUserId(userId);
        User contact = new User();
        contact.setUserId(contactId);
        removeContactService.execute(user, contact);
        return ResponseEntity.ok().build();
    }
}
