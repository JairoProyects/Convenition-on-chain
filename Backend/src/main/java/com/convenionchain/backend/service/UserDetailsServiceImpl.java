package com.convenionchain.backend.service;
// Updated imports to use entities from Luis Torres's package
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.Role; // Assuming User entity will have a getRoles() method returning Set<Role>
import com.zkbytebandits.convenio.entity.UserRole; // Import UserRole
import com.zkbytebandits.convenio.repository.user.UserRepository; // Assuming UserRepository path

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository userRepository;

    @Autowired
    public UserDetailsServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        // Get roles via the UserRole join entity
        Set<GrantedAuthority> authorities;
        if (user.getUserRoles() != null && !user.getUserRoles().isEmpty()) {
            authorities = user.getUserRoles().stream()
                    .map(UserRole::getRole)
                    .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getName().toUpperCase()))
                    .collect(Collectors.toSet());
        } else {
            authorities = Collections.emptySet(); // No roles or userRoles collection is null/empty
        }
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPasswordHash(),
                authorities);
    }
} 