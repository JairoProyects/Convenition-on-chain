import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  final bool isDarkMode;
  
  const RegisterPage({
    Key? key, 
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  
  // Controladores para los campos del formulario
  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Configurar animaciones
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    // Iniciar animación
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _identificationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Obtener el esquema de colores según el modo
  AppColorScheme get colorScheme => 
      widget.isDarkMode ? AppColors.dark : AppColors.light;

  // Simula la búsqueda de datos por identificación
  void _searchByIdentification() {
    // Aquí iría la lógica para buscar por cédula/identificación
    // Por ahora, solo simulamos con datos de ejemplo
    setState(() {
      _firstNameController.text = "Juan Carlos";
      _lastNameController.text = "Pérez González";
    });
    
    // Mostrar un snackbar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('User information retrieved successfully'),
        backgroundColor: colorScheme.accentBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? colorScheme.fallbackBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: widget.isDarkMode ? Brightness.light : Brightness.dark,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: colorScheme.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your details to get started today',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Campo de Identificación
                    _buildTextField(
                      label: 'Identification',
                      hint: 'Enter your ID number',
                      controller: _identificationController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ID number';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: colorScheme.textSecondary),
                        onPressed: _searchByIdentification,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Campos de Nombre y Apellido (deshabilitados)
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'First Name',
                            hint: 'First name',
                            controller: _firstNameController,
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: 'Last Name',
                            hint: 'Last name',
                            controller: _lastNameController,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo de Nombre de Usuario
                    _buildTextField(
                      label: 'Username',
                      hint: 'Enter your username',
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo de Email
                    _buildTextField(
                      label: 'Email Address',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo de Teléfono
                    _buildTextField(
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: widget.isDarkMode 
                                  ? Colors.grey.shade700 
                                  : Colors.grey.shade300,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          '+57',
                          style: TextStyle(
                            color: colorScheme.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo de Contraseña
                    _buildTextField(
                      label: 'Password',
                      hint: 'Please Enter Your Password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: colorScheme.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Checkbox "Remember Me" y "Forgot Password"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: colorScheme.accentBlue,
                                checkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                color: colorScheme.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Navegar a la pantalla de recuperación de contraseña
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: colorScheme.accentBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Botón de Sign Up
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Procesar el registro
                            print('Registro válido');
                            print('Identificación: ${_identificationController.text}');
                            print('Username: ${_usernameController.text}');
                            print('Email: ${_emailController.text}');
                            print('Nombre: ${_firstNameController.text}');
                            print('Apellido: ${_lastNameController.text}');
                            print('Teléfono: ${_phoneController.text}');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.accentBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: colorScheme.textHighlight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Divisor "Or With"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: widget.isDarkMode 
                                ? Colors.grey.shade700 
                                : Colors.grey.shade300,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or With',
                            style: TextStyle(
                              color: colorScheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: widget.isDarkMode 
                                ? Colors.grey.shade700 
                                : Colors.grey.shade300,
                            thickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Botones de redes sociales
                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            icon: Icons.code,
                            label: 'GitHub',
                            onPressed: () {
                              // Implementar inicio de sesión con GitHub
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSocialButton(
                            icon: Icons.code_off,
                            label: 'GitLab',
                            onPressed: () {
                              // Implementar inicio de sesión con GitLab
                            },
                            iconColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Enlace para iniciar sesión
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: colorScheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navegar a la pantalla de inicio de sesión
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Login',
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
                  ],
                ),
              ),
            ),
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
    bool enabled = true,
  }) {
    final borderRadius = BorderRadius.circular(8);
    final borderColor = widget.isDarkMode 
        ? Colors.grey.shade700 
        : Colors.grey.shade300;
    final fillColor = widget.isDarkMode 
        ? (enabled ? colorScheme.panelBackground : Colors.grey.shade800)
        : (enabled ? Colors.grey.shade50 : Colors.grey.shade100);
    
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          validator: validator,
          style: TextStyle(
            color: enabled ? colorScheme.textPrimary : colorScheme.textSecondary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.textSecondary.withOpacity(0.7),
              fontSize: 14,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              borderSide: BorderSide(color: colorScheme.accentBlue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
    final borderColor = widget.isDarkMode 
        ? Colors.grey.shade700 
        : Colors.grey.shade300;
    
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: widget.isDarkMode 
              ? colorScheme.panelBackground 
              : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor ?? colorScheme.textPrimary,
              size: 20,
            ),
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