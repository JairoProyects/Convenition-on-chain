import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.panelBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: colors.textPrimary,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: kToolbarHeight + 16),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-zaYQe9sngzvu2DSNu5P9ijXuVuQnk0.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text('Karl Edison', style: AppTextStyles.heading2(colors)),
                    const SizedBox(height: 4),
                    Text(
                      '@karledison',
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildMenuItem(
                      title: 'Edit profile',
                      icon: Icons.arrow_forward_ios,
                      onTap: () {},
                      colors: colors,
                    ),
                    _buildMenuItem(
                      title: 'Change Password',
                      icon: Icons.arrow_forward_ios,
                      onTap: () {},
                      colors: colors,
                    ),
                    _buildMenuItem(
                      title: 'Favourites',
                      icon: Icons.arrow_forward_ios,
                      onTap: () {},
                      colors: colors,
                    ),
                    _buildMenuItem(
                      title: 'Help',
                      icon: Icons.arrow_forward_ios,
                      onTap: () {},
                      colors: colors,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.logout,
                          color: colors.accentBlue,
                          size: 18,
                        ),
                        label: Text(
                          'Log out',
                          style: TextStyle(
                            color: colors.accentBlue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required AppColorScheme colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.panelBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.body(colors)),
              Icon(icon, size: 16, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
