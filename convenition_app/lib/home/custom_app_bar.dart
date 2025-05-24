import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/theme/app_colors.dart';
import '../shared/theme/app_text_styles.dart';
import '../shared/theme/theme_provider.dart';
import '../convenion/presentation/profile/profile_page.dart';
import '../shared/config/auth_config.dart';
import '../convenion/services/user_service.dart';

class CustomAppBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final TextEditingController controller;

  const CustomAppBar({
    super.key,
    required this.controller,
    this.onSearchChanged,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfileImage();
  }

  Future<void> _loadUserProfileImage() async {
    final userId = await AuthConfig.getUserSession();
    if (userId != null) {
      final user = await UserService().getUserById(userId.toString());
      if (mounted) {
        setState(() {
          _imageUrl = user.profileImageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.accentBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colors.panelBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: colors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onChanged: widget.onSearchChanged,
                    style: AppTextStyles.body(colors),
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      hintStyle: AppTextStyles.bodyMuted(colors),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: colors.textSecondary,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        const SizedBox(width: 12),
        Icon(Icons.notifications_outlined, color: colors.textSecondary),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () async {
            final userId = await AuthConfig.getUserSession();
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(userId: userId ?? 0),
                ),
              );
            }
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _imageUrl != null
                    ? NetworkImage(_imageUrl!)
                    : const NetworkImage(
                        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/placeholder-ob7miW3mUreePYfXdVwkpFWHthzoR5.svg',
                      ),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
