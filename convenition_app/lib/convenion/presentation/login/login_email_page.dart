import 'package:convenition_app/convenion/domains/user_model.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../services/user_service.dart';
import '../../../home/bottom_navigation_bar.dart';
import '../../../shared/config/auth_config.dart';

class LoginEmailPage extends StatefulWidget {
  final bool isDarkMode;

  const LoginEmailPage({super.key, this.isDarkMode = true});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  AppColorScheme get colorScheme =>
      widget.isDarkMode ? AppColors.dark : AppColors.light;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    _buttonAnimationController.forward();

    try {
      final loginRequest = LoginRequest(
        email: _emailController.text.trim(),
        clave: _passwordController.text.trim(),
      );

      final response = await UserService().loginUser(loginRequest);

      // TODO: Guarda token y datos del usuario si es necesario, por ejemplo con SharedPreferences

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Inicio de sesión exitoso!'),
              ],
            ),
            backgroundColor: colorScheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        await AuthConfig.saveUserSession(response.userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuTopTabsPage(userId: response.userId)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _buttonAnimationController.reverse();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? colorScheme.fallbackBackground : Colors.white,
      body: Container(
        decoration:
            widget.isDarkMode
                ? BoxDecoration(gradient: colorScheme.backgroundMain)
                : null,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            widget.isDarkMode
                                ? colorScheme.panelBackground.withOpacity(0.5)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.textPrimary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Hola, ¡bienvenido de nuevo!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.textPrimary,
                                  ),
                                ),
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 800),
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: value * 0.5,
                                      child: const Text(
                                        '👋',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hola de nuevo, ¡te extrañamos!',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildTextField(
                              label: 'Correo electrónico',
                              hint: 'Ingrese su correo electrónico',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: colorScheme.textSecondary,
                                size: 20,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su correo';
                                }
                                if (!RegExp(
                                  r'^[\w\.-]+@[\w\.-]+\.\w{2,}$',
                                ).hasMatch(value)) {
                                  return 'Por favor ingrese un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Contraseña',
                              hint: 'Ingrese su contraseña',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: colorScheme.textSecondary,
                                size: 20,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su contraseña';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: colorScheme.textSecondary,
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    color: colorScheme.accentBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            AnimatedBuilder(
                              animation: _buttonScaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _buttonScaleAnimation.value,
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          colorScheme.accentBlue,
                                          colorScheme.accentBlue.withOpacity(
                                            0.8,
                                          ),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.accentBlue
                                              .withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                        ),
                                      ),
                                      child:
                                          _isLoading
                                              ? CircularProgressIndicator(
                                                color:
                                                    colorScheme.textHighlight,
                                                strokeWidth: 2,
                                              )
                                              : Text(
                                                'Iniciar sesión',
                                                style: TextStyle(
                                                  color:
                                                      colorScheme.textHighlight,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color:
                                        widget.isDarkMode
                                            ? colorScheme.borderGlow
                                                .withOpacity(0.3)
                                            : Colors.grey.shade300,
                                    thickness: 0.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'O continuar con',
                                    style: TextStyle(
                                      color: colorScheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color:
                                        widget.isDarkMode
                                            ? colorScheme.borderGlow
                                                .withOpacity(0.3)
                                            : Colors.grey.shade300,
                                    thickness: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSocialButton(
                              icon: Icons.g_mobiledata,
                              label: 'Continuar con Google',
                              onPressed: () {},
                              iconColor: Colors.redAccent,
                            ),
                            const SizedBox(height: 60),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¿No tenés una cuenta? ',
                                    style: TextStyle(
                                      color: colorScheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        color: colorScheme.accentBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    final borderRadius = BorderRadius.circular(12);
    final borderColor =
        widget.isDarkMode
            ? colorScheme.borderGlow.withOpacity(0.3)
            : Colors.grey.shade300;
    final fillColor =
        widget.isDarkMode
            ? colorScheme.panelBackground.withOpacity(0.5)
            : Colors.grey.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow:
                widget.isDarkMode
                    ? []
                    : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(color: colorScheme.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: colorScheme.textSecondary.withOpacity(0.7),
                fontSize: 14,
              ),
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: colorScheme.accentBlue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    final borderColor =
        widget.isDarkMode
            ? colorScheme.borderGlow.withOpacity(0.3)
            : Colors.grey.shade300;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            widget.isDarkMode
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor:
              widget.isDarkMode
                  ? colorScheme.panelBackground.withOpacity(0.5)
                  : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? colorScheme.textPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
