import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starknet/starknet.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_dropdown_search.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../domains/user_model.dart';
import '../../domains/convenio_model.dart';
import './review_agreement_page.dart';

class CreateSelectUserPage extends StatefulWidget {
  final AgreementDraft draft;

  const CreateSelectUserPage({Key? key, required this.draft}) : super(key: key);

  @override
  State<CreateSelectUserPage> createState() => _CreateSelectUserPageState();
}

class _CreateSelectUserPageState extends State<CreateSelectUserPage>
    with TickerProviderStateMixin {
  UserModel? _selectedUser;
  bool _isLoading = false;
  bool _showUserDetails = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _userCardController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _userCardAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _userCardController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Asegurar que todas las animaciones estén en el rango correcto
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    // Corregir la animación de la tarjeta de usuario
    _userCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _userCardController, curve: Curves.easeOutBack),
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
    _userCardController.dispose();
    super.dispose();
  }

  void _onUserSelected(UserModel? user) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedUser = user;
      _showUserDetails = user != null;
    });

    if (user != null) {
      _userCardController.reset();
      _userCardController.forward();
    }
  }

  void _confirmUser() async {
    if (_selectedUser == null) {
      HapticFeedback.heavyImpact();
      _showErrorDialog();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    // Simular procesamiento
    await Future.delayed(const Duration(milliseconds: 1200));

    final updatedDraft = AgreementDraft(
      monto: widget.draft.monto,
      moneda: widget.draft.moneda,
      descripcion: widget.draft.descripcion,
      condiciones: widget.draft.condiciones,
      vencimiento: widget.draft.vencimiento,
      party1: widget.draft.party1,
      party2: "",
    );

    setState(() => _isLoading = false);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ReviewAgreementPage(
          draft: updatedDraft,
          usuario: _selectedUser!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showErrorDialog() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.modalBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              "Error",
              style: TextStyle(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          "Debés seleccionar un usuario para continuar.",
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: colors.accentBlue),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedWidget({required Widget child, required int index}) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value.dy * (index + 1) * 20),
          child: FadeTransition(opacity: _fadeAnimation, child: child),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: colors.accentBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 4,
              decoration: BoxDecoration(
                color: _selectedUser != null ? colors.accentBlue : colors.borderGlow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: colors.borderGlow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementSummary() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: colors.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderGlow, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.accentBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.description, color: colors.accentBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Resumen del Convenio',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow(
                  icon: Icons.attach_money,
                  label: 'Monto',
                  value: '${widget.draft.monto} ${widget.draft.moneda}',
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  icon: Icons.text_snippet,
                  label: 'Descripción',
                  value: widget.draft.descripcion,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  icon: Icons.rule,
                  label: 'Condiciones',
                  value: widget.draft.condiciones,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  icon: Icons.calendar_today,
                  label: 'Vencimiento',
                  value: widget.draft.vencimiento.toLocal().toString().split(' ')[0],
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColorScheme colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colors.accentBlue, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return AnimatedBuilder(
      animation: _userCardAnimation,
      builder: (context, child) {
        // CORRECCIÓN: Asegurar que los valores estén en el rango válido
        final opacity = _userCardAnimation.value.clamp(0.0, 1.0);
        final scale = _userCardAnimation.value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: colors.panelBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.accentBlue.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.accentBlue.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.accentBlue.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.accentBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Usuario Seleccionado',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.check_circle,
                          color: colors.accentBlue,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildUserDetailRow(
                          icon: Icons.person_outline,
                          label: 'Nombre',
                          value: "${_selectedUser!.firstName ?? ''} ${_selectedUser!.lastName ?? ''}".trim(),
                          colors: colors,
                        ),
                        const SizedBox(height: 12),
                        _buildUserDetailRow(
                          icon: Icons.alternate_email,
                          label: 'Username',
                          value: _selectedUser!.username ?? 'N/A',
                          colors: colors,
                        ),
                        const SizedBox(height: 12),
                        _buildUserDetailRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: _selectedUser!.email ?? 'N/A',
                          colors: colors,
                        ),
                        const SizedBox(height: 12),
                        _buildUserDetailRow(
                          icon: Icons.info_outline,
                          label: 'Estado',
                          value: _selectedUser!.status?.name.toUpperCase() ?? 'N/A',
                          colors: colors,
                          isStatus: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColorScheme colors,
    bool isStatus = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colors.accentBlue, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              isStatus
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.accentBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: colors.accentBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: colors.panelBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderGlow, width: 1),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_back,
                  color: colors.textSecondary,
                  size: 18,
                ),
                label: Text(
                  "Volver",
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: _selectedUser != null ? colors.buttonSlideToSwap : null,
                color: _selectedUser == null ? colors.panelBackground : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _selectedUser != null
                    ? [
                        BoxShadow(
                          color: colors.accentBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton.icon(
                onPressed: _selectedUser != null && !_isLoading ? _confirmUser : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.accentBlue,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward,
                        color: _selectedUser != null
                            ? colors.accentBlue
                            : colors.textSecondary,
                        size: 18,
                      ),
                label: Text(
                  _isLoading ? "Procesando..." : "Siguiente",
                  style: TextStyle(
                    color: _selectedUser != null
                        ? colors.accentBlue
                        : colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Seleccionar Usuario',
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedWidget(
                  index: 0,
                  child: BreadcrumbWidget(
                    items: ['Inicio', 'Convenios', 'Seleccionar Usuario'],
                    colors: colors,
                    onTap: (idx) {
                      HapticFeedback.lightImpact();
                      if (idx == 0) {
                        Navigator.popUntil(context, (r) => r.isFirst);
                      } else if (idx == 1) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),

                _buildProgressIndicator(),

                Expanded(
                  child: ListView(
                    children: [
                      _buildAnimatedWidget(
                        index: 1,
                        child: _buildAgreementSummary(),
                      ),

                      _buildAnimatedWidget(
                        index: 2,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: colors.panelBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colors.borderGlow,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: colors.accentBlue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Buscar Usuario',
                                      style: TextStyle(
                                        color: colors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                UserDropdownSearch(
                                  onUserSelected: _onUserSelected,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (_showUserDetails && _selectedUser != null)
                        _buildUserCard(),
                    ],
                  ),
                ),

                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
