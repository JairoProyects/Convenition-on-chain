import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/config/auth_config.dart';
import '../../services/user_service.dart';
import '../../domains/user_model.dart';
import '../../presentation/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserService().getUserById(widget.userId.toString());
      setState(() {
        _user = user;
        _usernameController.text = user.username ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar el perfil: $e')));
    }
  }

  Future<void> _submitChanges() async {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las nuevas contraseñas no coinciden')),
      );
      return;
    }

    try {
      final dto = UpdateUserDto(
        username: _usernameController.text,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmNewPasswordController.text,
      );
      final updatedUser = await UserService().updateUser(widget.userId, dto);
      setState(() {
        _user = updatedUser;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar perfil: $e')));
    }
  }

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
          'Perfil',
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
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          top: kToolbarHeight + 16,
                        ),
                        child: Column(
                          children: [
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
                            Text(
                              _user != null
                                  ? '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}'
                                          .trim()
                                          .isEmpty
                                      ? 'Nombre no disponible'
                                      : '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}'
                                          .trim()
                                  : 'Nombre no disponible',
                              style: AppTextStyles.heading2(colors),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _user?.email ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildMenuItem(
                              title:
                                  _isEditing
                                      ? 'Cancelar edición'
                                      : 'Editar perfil',
                              icon: Icons.edit,
                              onTap: () {
                                setState(() {
                                  _isEditing = !_isEditing;
                                });
                              },
                              colors: colors,
                            ),
                            if (_isEditing)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _usernameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre de usuario',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _currentPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Contraseña actual',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _newPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Nueva contraseña',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _confirmNewPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Confirmar nueva contraseña',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: _submitChanges,
                                      icon: const Icon(Icons.save),
                                      label: const Text('Guardar cambios'),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            _buildMenuItem(
                              title: 'Ayuda',
                              icon: Icons.arrow_forward_ios,
                              onTap: () {},
                              colors: colors,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextButton.icon(
                                onPressed: () async {
                                  await AuthConfig.logout();
                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: colors.accentBlue,
                                  size: 18,
                                ),
                                label: Text(
                                  'Cerrar sesión',
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
