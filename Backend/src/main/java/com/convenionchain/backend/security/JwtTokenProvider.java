package com.convenionchain.backend.security;

////import io.jsonwebtoken.*;
////import io.jsonwebtoken.security.Keys;
//import jakarta.annotation.PostConstruct;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.stereotype.Component;
//
//import javax.crypto.SecretKey;
//import java.util.Date;
//
//@Component
//public class JwtTokenProvider {
//
//    private static final Logger logger = LoggerFactory.getLogger(JwtTokenProvider.class);
//
//    @Value("${app.jwt.secret}")
//    private String jwtSecretString;
//
//    @Value("${app.jwt.expiration-ms}")
//    private int jwtExpirationMs;
//
//    private SecretKey jwtSecretKey;
//
//    @PostConstruct
//    public void init() {
//        // Ensure the secret string is strong enough for HS256
//        // For HS256, the key size must be at least 256 bits (32 bytes)
//        // If your jwtSecretString is shorter, this will need adjustment or use a key generation strategy.
//        // For simplicity, this example assumes jwtSecretString is a base64 encoded string that is long enough.
//        // In a real app, generate a secure key and store it safely.
//        // byte[] keyBytes = Decoders.BASE64.decode(jwtSecretString);
//        // this.jwtSecretKey = Keys.hmacShaKeyFor(keyBytes);
//        // For now, let's generate a key if the provided one is not suitable, good for dev
//        // THIS IS NOT SECURE FOR PRODUCTION if jwtSecretString is weak or default
//        if (jwtSecretString == null || jwtSecretString.length() < 32) {
//            logger.warn("JWT secret is not configured or too short. Generating a temporary key for development.");
//            this.jwtSecretKey = Keys.secretKeyFor(SignatureAlgorithm.HS256); // Generates a secure key
//        } else {
//            // Assuming the jwtSecretString from properties is a raw string for the key
//            // It should be a securely generated and stored key, e.g., base64 encoded.
//            // For simplicity, if it's a plain string, we'll use its bytes. This might not be ideal for all encoding of secrets.
//            this.jwtSecretKey = Keys.hmacShaKeyFor(jwtSecretString.getBytes());
//        }
//    }
//
//    public String generateToken(Authentication authentication) {
//        UserDetails userPrincipal = (UserDetails) authentication.getPrincipal();
//        return generateTokenFromUsername(userPrincipal.getUsername());
//    }
//
//    public String generateTokenFromUsername(String username) {
//        Date now = new Date();
//        Date expiryDate = new Date(now.getTime() + jwtExpirationMs);
//
//        return Jwts.builder()
//                .setSubject(username)
//                .setIssuedAt(new Date())
//                .setExpiration(expiryDate)
//                .signWith(jwtSecretKey, SignatureAlgorithm.HS256)
//                .compact();
//    }
//
//    public String getUsernameFromJWT(String token) {
//        Claims claims = Jwts.parserBuilder()
//                .setSigningKey(jwtSecretKey)
//                .build()
//                .parseClaimsJws(token)
//                .getBody();
//
//        return claims.getSubject();
//    }
//
//    public boolean validateToken(String authToken) {
//        try {
//            Jwts.parserBuilder().setSigningKey(jwtSecretKey).build().parseClaimsJws(authToken);
//            return true;
//        } catch (MalformedJwtException ex) {
//            logger.error("Invalid JWT token: {}", ex.getMessage());
//        } catch (ExpiredJwtException ex) {
//            logger.error("Expired JWT token: {}", ex.getMessage());
//        } catch (UnsupportedJwtException ex) {
//            logger.error("Unsupported JWT token: {}", ex.getMessage());
//        } catch (IllegalArgumentException ex) {
//            logger.error("JWT claims string is empty: {}", ex.getMessage());
//        } catch (SecurityException ex) { // This can be thrown by Keys.hmacShaKeyFor with invalid keys
//             logger.error("JWT signature validation failed: {}", ex.getMessage());
//        }
//        return false;
//    }
//}