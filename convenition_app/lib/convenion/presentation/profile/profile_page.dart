import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/config/auth_config.dart';
import '../../services/user_service.dart';
import '../../services/user_profile_service.dart';
import '../../domains/user_model.dart';
import '../../presentation/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  File? _profileImage;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _avatarController;
  late AnimationController _editController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _avatarAnimation;
  late Animation<double> _editAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUser();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _editController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

  // Asegurar que las animaciones de opacidad estén en el rango correcto
  _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
  );
  _slideAnimation = Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
  _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
    CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
  );
  _avatarAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
    CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
  );
  // Corregir la animación de edición para asegurar valores válidos
  _editAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _editController, curve: Curves.easeOutBack),
  );
}

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _avatarController.dispose();
    _editController.dispose();
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserService().getUserById(widget.userId.toString());
      setState(() {
        _user = user;
        _usernameController.text = user.username ?? '';
        _isLoading = false;
      });
      _startAnimations();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error al cargar el perfil: $e', isError: true);
    }
  }

  Future<void> _pickImage() async {
    HapticFeedback.lightImpact();
    _avatarController.forward().then((_) => _avatarController.reverse());
    
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      
      try {
        await UserProfileService().uploadProfileImage(
          userId: widget.userId,
          imageFile: _profileImage!,
        );
        _showSnackBar('Imagen de perfil actualizada');
      } catch (e) {
        _showSnackBar('Error al subir la imagen: $e', isError: true);
      }
    }
  }

  Future<void> _submitChanges() async {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      _showSnackBar('Las nuevas contraseñas no coinciden', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

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
        _isSaving = false;
      });
      
      _editController.reverse();
      _showSnackBar('Perfil actualizado correctamente');
      
      // Limpiar campos de contraseña
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
      
    } catch (e) {
      setState(() => _isSaving = false);
      _showSnackBar('Error al actualizar perfil: $e', isError: true);
    }
  }

  void _toggleEdit() {
    HapticFeedback.lightImpact();
    setState(() {
      _isEditing = !_isEditing;
    });
    
    if (_isEditing) {
      _editController.forward();
    } else {
      _editController.reverse();
      // Limpiar campos al cancelar
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
        
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : colors.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAnimatedWidget({
    required Widget child,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value.dy * (index + 1) * 20),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.accentBlue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.accentBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cargando perfil...',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return _buildAnimatedWidget(
      index: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.accentBlue.withOpacity(0.1),
              colors.accentGreen.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderGlow, width: 1),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: AnimatedBuilder(
                animation: _avatarAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _avatarAnimation.value,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colors.accentBlue.withOpacity(0.3),
                                colors.accentGreen.withOpacity(0.3),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.accentBlue.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (_profileImage == null &&
                                      (_user?.profileImageUrl == null ||
                                          _user!.profileImageUrl!.isEmpty))
                                  ? colors.panelBackground
                                  : null,
                              image: (_profileImage != null ||
                                      (_user?.profileImageUrl?.isNotEmpty ?? false))
                                  ? DecorationImage(
                                      image: _profileImage != null
                                          ? FileImage(_profileImage!)
                                          : NetworkImage(_user!.profileImageUrl!)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: (_profileImage == null &&
                                    (_user?.profileImageUrl == null ||
                                        _user!.profileImageUrl!.isEmpty))
                                ? Icon(
                                    Icons.person,
                                    size: 48,
                                    color: colors.textSecondary,
                                  )
                                : null,
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _user != null
                  ? '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}'
                          .trim()
                          .isEmpty
                      ? 'Nombre no disponible'
                      : '${_user!.firstName ?? ''} ${_user!.lastName ?? ''}'.trim()
                  : 'Nombre no disponible',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.accentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _user?.email ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.accentBlue,
                  fontWeight: FontWeight.w500,
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
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return _buildAnimatedWidget(
      index: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: colors.panelBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderGlow, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? colors.accentBlue).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: iconColor ?? colors.accentBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDestructive ? Colors.redAccent : colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

  return AnimatedBuilder(
    animation: _editAnimation,
    builder: (context, child) {
      // Asegurar que la opacidad esté en el rango válido
      final opacity = _editAnimation.value.clamp(0.0, 1.0);
      final scale = _editAnimation.value.clamp(0.0, 1.0);
      
      return Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.panelBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.borderGlow, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit, color: colors.accentBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Editar Perfil',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Nombre de usuario',
                    icon: Icons.person_outline,
                    colors: colors,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _currentPasswordController,
                    label: 'Contraseña actual',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscureCurrentPassword,
                    onToggleVisibility: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                    colors: colors,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _newPasswordController,
                    label: 'Nueva contraseña',
                    icon: Icons.lock_reset,
                    isPassword: true,
                    obscureText: _obscureNewPassword,
                    onToggleVisibility: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                    colors: colors,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _confirmNewPasswordController,
                    label: 'Confirmar nueva contraseña',
                    icon: Icons.lock_clock,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    colors: colors,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _toggleEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.panelBackground,
                            foregroundColor: colors.textSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: colors.borderGlow),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colors.accentBlue, colors.accentBlue.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _submitChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Guardar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required AppColorScheme colors,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.panelBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderGlow.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colors.textSecondary),
          prefixIcon: Icon(icon, color: colors.accentBlue, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: colors.textSecondary,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    if (_isLoading) return _buildLoadingState();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.panelBackground.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: colors.textPrimary,
              size: 16,
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Perfil',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                
                _buildMenuItem(
                  title: _isEditing ? 'Cancelar edición' : 'Editar perfil',
                  icon: _isEditing ? Icons.close : Icons.edit,
                  onTap: _toggleEdit,
                  colors: colors,
                ),
                
                if (_isEditing) _buildEditForm(),
                
                _buildMenuItem(
                  title: 'Configuración',
                  icon: Icons.settings,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Navegar a configuración
                  },
                  colors: colors,
                ),
                
                _buildMenuItem(
                  title: 'Ayuda y soporte',
                  icon: Icons.help_outline,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Navegar a ayuda
                  },
                  colors: colors,
                ),
                
                _buildMenuItem(
                  title: 'Acerca de',
                  icon: Icons.info_outline,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Mostrar información de la app
                  },
                  colors: colors,
                ),
                
                const SizedBox(height: 20),
                
                _buildMenuItem(
                  title: 'Cerrar sesión',
                  icon: Icons.logout,
                  iconColor: Colors.redAccent,
                  isDestructive: true,
                  onTap: () async {
                    HapticFeedback.heavyImpact();
                    await AuthConfig.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  },
                  colors: colors,
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
