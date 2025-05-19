package com.zkbytebandits.convenio.controller.userDetails;

//import com.zkbytebandits.convenio.service.UserDetailsServiceImpl;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.security.core.userdetails.UserDetails;
//
//@RestController
//@RequestMapping("/api/userdetails")
//public class UserDetailsController {
//
//    private final UserDetailsServiceImpl userDetailsService;
//
//    @Autowired
//    public UserDetailsController(UserDetailsServiceImpl userDetailsService) {
//        this.userDetailsService = userDetailsService;
//    }
//
//    @GetMapping("/{email}")
//    public UserDetails loadUserByUsername(@PathVariable String email) {
//        return userDetailsService.loadUserByUsername(email);
//    }
//
//    // Add controller methods here
//}