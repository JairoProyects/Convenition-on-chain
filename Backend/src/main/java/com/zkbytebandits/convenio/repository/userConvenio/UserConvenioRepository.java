package com.zkbytebandits.convenio.repository.userConvenio;

import com.zkbytebandits.convenio.entity.Convenio;
import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.entity.UserConvenio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserConvenioRepository extends JpaRepository<UserConvenio, Long> {
    
    List<UserConvenio> findByUser(User user);
    
    List<UserConvenio> findByConvenio(Convenio convenio);
    
    Optional<UserConvenio> findByUserAndConvenio(User user, Convenio convenio);
    
    List<UserConvenio> findByUserAndRole(User user, UserConvenio.UserConvenioRole role);
    
    List<UserConvenio> findByConvenioAndRole(Convenio convenio, UserConvenio.UserConvenioRole role);
    
    List<UserConvenio> findByUserAndStatus(User user, UserConvenio.UserConvenioStatus status);
    
    List<UserConvenio> findByConvenioAndStatus(Convenio convenio, UserConvenio.UserConvenioStatus status);
    
    void deleteByUserAndConvenio(User user, Convenio convenio);
    
    boolean existsByUserAndConvenio(User user, Convenio convenio);
}
