import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starknet/starknet.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../../shared/util/notifications.dart';
import '../../domains/convenio_model.dart';
import '../../domains/user_model.dart';
import '../../services/starknet_service.dart';
import './result_agreement_page.dart';

class ReviewAgreementPage extends StatefulWidget {
  final AgreementDraft draft;
  final UserModel usuario;

  const ReviewAgreementPage({
    Key? key,
    required this.draft,
    required this.usuario,
  }) : super(key: key);

  @override
  State<ReviewAgreementPage> createState() => _ReviewAgreementPageState();
}

class _ReviewAgreementPageState extends State<ReviewAgreementPage>
    with TickerProviderStateMixin {
  bool _isProcessing = false;
  bool _showConfirmation = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _confirmController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _confirmAnimation;

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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _confirmController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _confirmAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confirmController, curve: Curves.easeOutBack),
    );

    _pulseController.repeat(reverse: true);
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
    _pulseController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isProcessing = true;
      _showConfirmation = true;
    });
    
    _confirmController.forward();

    try {
      // Simular procesamiento
      await Future.delayed(const Duration(milliseconds: 2500));

      Future<void> navigateToResultPage() async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AgreementResultPage(
                  draft: widget.draft,
                  usuario: widget.usuario,
                  onChainHash: "txHash",
                ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }

      await showSwapModal(context, () async {
        // Lógica de transacción aquí
      });

      await navigateToResultPage();
    } catch (e) {
      HapticFeedback.heavyImpact();
      print("Error al confirmar convenio: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
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
                color: _isProcessing ? colors.accentBlue : colors.accentBlue.withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, IconData icon, AppColorScheme colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.panelBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderGlow.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colors.accentBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: colors.accentBlue,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData titleIcon,
    AppColorScheme colors,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: colors.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderGlow, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    titleIcon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationOverlay() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return AnimatedBuilder(
      animation: _confirmAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.7 * _confirmAnimation.value),
            child: Center(
              child: Transform.scale(
                scale: _confirmAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.modalBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: colors.accentBlue.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.rocket_launch,
                                color: colors.accentBlue,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Procesando Convenio',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creando tu convenio en la blockchain...',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.accentBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.accentBlue,
              colors.accentBlue.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.accentBlue.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _isProcessing ? null : _onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: _isProcessing
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 24,
                ),
          label: Text(
            _isProcessing ? 'Procesando...' : 'Confirmar Contrato',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Revisión del Convenio',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: colors.backgroundMain),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAnimatedWidget(
                      index: 0,
                      child: BreadcrumbWidget(
                        items: ['Inicio', 'Convenios', 'Revisión Final'],
                        colors: colors,
                        onTap: (idx) {
                          HapticFeedback.lightImpact();
                          if (idx == 0) {
                            Navigator.popUntil(context, (r) => r.isFirst);
                          } else {
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
                            child: _buildSection(
                              'Datos del Convenio',
                              Icons.description,
                              colors,
                              [
                                _buildDataRow(
                                  'Descripción',
                                  widget.draft.descripcion,
                                  Icons.text_snippet,
                                  colors,
                                ),
                                _buildDataRow(
                                  'Condiciones',
                                  widget.draft.condiciones,
                                  Icons.rule,
                                  colors,
                                ),
                                _buildDataRow(
                                  'Monto',
                                  '${widget.draft.moneda} ${widget.draft.monto.toStringAsFixed(2)}',
                                  Icons.attach_money,
                                  colors,
                                ),
                                _buildDataRow(
                                  'Vencimiento',
                                  widget.draft.vencimiento.toLocal().toString().split(' ')[0],
                                  Icons.calendar_today,
                                  colors,
                                ),
                              ],
                            ),
                          ),

                          _buildAnimatedWidget(
                            index: 2,
                            child: _buildSection(
                              'Usuario Destinatario',
                              Icons.person,
                              colors,
                              [
                                _buildDataRow(
                                  'Nombre',
                                  '${widget.usuario.firstName ?? ''} ${widget.usuario.lastName ?? ''}'.trim(),
                                  Icons.person_outline,
                                  colors,
                                ),
                                _buildDataRow(
                                  'Username',
                                  widget.usuario.username ?? 'N/A',
                                  Icons.alternate_email,
                                  colors,
                                ),
                                _buildDataRow(
                                  'Email',
                                  widget.usuario.email ?? 'N/A',
                                  Icons.email_outlined,
                                  colors,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors.panelBackground.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: colors.borderGlow.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: colors.accentGreen.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          Icons.verified_user,
                                          color: colors.accentGreen,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Estado',
                                              style: TextStyle(
                                                color: colors.textSecondary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: colors.accentGreen.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                widget.usuario.status?.name.toUpperCase() ?? 'N/A',
                                                style: TextStyle(
                                                  color: colors.accentGreen,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ),
          ),
          if (_showConfirmation) _buildConfirmationOverlay(),
        ],
      ),
    );
  }
}
