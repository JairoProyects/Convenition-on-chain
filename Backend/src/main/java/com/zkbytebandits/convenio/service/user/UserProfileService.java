package com.zkbytebandits.convenio.service.user;

import com.zkbytebandits.convenio.entity.User;
import com.zkbytebandits.convenio.repository.user.UserRepository;
import com.zkbytebandits.convenio.service.file.FileStorageService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class UserProfileService {

    private final UserRepository userRepository;
    private final FileStorageService fileStorageService;

    @Autowired
    public UserProfileService(UserRepository userRepository, FileStorageService fileStorageService) {
        this.userRepository = userRepository;
        this.fileStorageService = fileStorageService;
    }

    /**
     * Updates a user's profile image.
     *
     * @param userId The ID of the user whose profile image will be updated
     * @param imageFile The new profile image
     * @return The URL where the profile image can be accessed
     * @throws EntityNotFoundException if the user doesn't exist
     * @throws IOException if there's a problem storing the file
     */
    public String updateProfileImage(Long userId, MultipartFile imageFile) throws EntityNotFoundException, IOException {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));

        // Store the file and get its URL
        String imageUrl = fileStorageService.storeFile(imageFile);

        // Update the user's profile image URL
        user.setProfileImageUrl(imageUrl);
        userRepository.save(user);

        return imageUrl;
    }
} 