import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../domains/user_model.dart';
import '../../domains/convenio_model.dart';
import '../../services/convenio_service.dart';

class AgreementResultPage extends StatefulWidget {
  final AgreementDraft draft;
  final UserModel usuario;
  final String onChainHash;

  const AgreementResultPage({
    Key? key,
    required this.draft,
    required this.usuario,
    required this.onChainHash,
  }) : super(key: key);

  @override
  State<AgreementResultPage> createState() =>
      _AgreementResultPageState();
}

class _AgreementResultPageState
    extends State<AgreementResultPage>
    with TickerProviderStateMixin {
  late ConvenioModel? convenio;
  bool _loading = true;
  String? _error;

  late AnimationController _celebrationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _qrController;
  late AnimationController _confettiController;

  late Animation<double> _celebrationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _qrAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _createConvenio();
  }

  void _initializeAnimations() {
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
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
    _qrController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _qrAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _qrController, curve: Curves.easeOutBack),
    );
    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
  }

  void _startSuccessAnimations() {
    _celebrationController.forward();
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();

    Timer(const Duration(milliseconds: 500), () {
      _qrController.forward();
    });

    Timer(const Duration(milliseconds: 800), () {
      _confettiController.forward();
    });

    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _qrController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _createConvenio() async {
    try {
      final dto = CreateConvenioDto(
        monto: widget.draft.monto,
        moneda: widget.draft.moneda,
        descripcion: widget.draft.descripcion,
        condiciones: widget.draft.condiciones,
        vencimiento: widget.draft.vencimiento,
        onChainHash: widget.onChainHash,
      );

      final created = await ConvenioService().createConvenio(dto);

      setState(() {
        convenio = created;
        _loading = false;
      });

      _startSuccessAnimations();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Widget _buildLoadingState() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.accentBlue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Finalizando convenio...',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Guardando en la blockchain',
                style: TextStyle(color: colors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent, size: 80),
                const SizedBox(height: 24),
                Text(
                  'Error al crear convenio',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error ?? 'Error desconocido',
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed:
                      () => Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Volver al Inicio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiParticle(double x, double y, Color color) {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return Positioned(
          left: x,
          top: y - (_confettiAnimation.value * 200),
          child: Transform.rotate(
            angle: _confettiAnimation.value * 4 * math.pi,
            child: Opacity(
              opacity: 1 - _confettiAnimation.value,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfettiOverlay() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Stack(
      children: List.generate(20, (index) {
        final random = math.Random(index);
        return _buildConfettiParticle(
          random.nextDouble() * MediaQuery.of(context).size.width,
          100 + random.nextDouble() * 100,
          [
            colors.accentBlue,
            colors.accentGreen,
            Colors.orange,
            Colors.purple,
            Colors.pink,
          ][index % 5],
        );
      }),
    );
  }

  Widget _buildSuccessHeader() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return AnimatedBuilder(
      animation: _celebrationAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _celebrationAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.accentGreen.withOpacity(0.2),
                  colors.accentBlue.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors.accentGreen.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.accentGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.accentGreen.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  '¡Convenio Creado!',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu convenio ha sido registrado exitosamente en la blockchain',
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHashSection() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  Icon(Icons.link, color: colors.accentBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Hash On-Chain',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.accentBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        widget.onChainHash,
                        style: TextStyle(
                          color: colors.accentBlue,
                          fontSize: 12,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Clipboard.setData(
                          ClipboardData(text: widget.onChainHash),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Hash copiado al portapapeles'),
                            backgroundColor: colors.accentGreen,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.copy,
                        color: colors.accentBlue,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRSection() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return AnimatedBuilder(
      animation: _qrAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _qrAnimation.value,
          child: Opacity(
            opacity: _qrAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.panelBackground,
                borderRadius: BorderRadius.circular(20),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, color: colors.accentBlue, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Código QR',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Escaneá este código para compartir el convenio',
                    style: TextStyle(color: colors.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _buildQrData(),
                      version: QrVersions.auto,
                      size: 180.0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Share.share(_buildQrData().trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentBlue.withOpacity(0.1),
                      foregroundColor: colors.accentBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colors.accentBlue.withOpacity(0.3),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Compartir'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.panelBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderGlow.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.accentBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colors.accentBlue, size: 18),
          ),
          const SizedBox(width: 16),
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

  Widget _buildDetailsSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildInfoTile(
              'Descripción',
              widget.draft.descripcion,
              Icons.description,
            ),
            _buildInfoTile('Condiciones', widget.draft.condiciones, Icons.rule),
            _buildInfoTile(
              'Monto',
              '${widget.draft.moneda} ${widget.draft.monto.toStringAsFixed(2)}',
              Icons.attach_money,
            ),
            _buildInfoTile(
              'Vencimiento',
              widget.draft.vencimiento.toLocal().toString().split(' ')[0],
              Icons.calendar_today,
            ),
            _buildInfoTile(
              'Destinatario',
              '${widget.usuario.firstName} ${widget.usuario.lastName}',
              Icons.person,
            ),
            _buildInfoTile(
              'Correo',
              widget.usuario.email ?? 'N/A',
              Icons.email,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.accentBlue, colors.accentBlue.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.accentBlue.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.popUntil(context, (r) => r.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.home, color: Colors.white, size: 20),
          label: const Text(
            'Volver al Inicio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    if (_loading) return _buildLoadingState();
    if (_error != null) return _buildErrorState();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contrato Confirmado',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: colors.backgroundMain),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSuccessHeader(),
                    const SizedBox(height: 24),
                    _buildHashSection(),
                    const SizedBox(height: 24),
                    _buildQRSection(),
                    const SizedBox(height: 24),
                    _buildDetailsSection(),
                    const SizedBox(height: 32),
                    _buildActionButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          _buildConfettiOverlay(),
        ],
      ),
    );
  }

  String _buildQrData() {
    return '''
    Descripción: ${widget.draft.descripcion}
    Condiciones: ${widget.draft.condiciones}
    Monto: ${widget.draft.moneda} ${widget.draft.monto.toStringAsFixed(2)}
    Vencimiento: ${widget.draft.vencimiento.toLocal().toString().split(' ')[0]}
    Destinatario: ${widget.usuario.firstName} ${widget.usuario.lastName}
    Correo: ${widget.usuario.email ?? 'N/A'}
    Hash On-Chain: ${widget.onChainHash}
        ''';
  }
}
