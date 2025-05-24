import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/util/validators.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import 'create_select_user_page.dart';
import '../../domains/convenio_model.dart';

class CreateAgreementPage extends StatefulWidget {
  const CreateAgreementPage({super.key});

  @override
  State<CreateAgreementPage> createState() => _CreateAgreementPageState();
}

class _CreateAgreementPageState extends State<CreateAgreementPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _condicionesController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  DateTime? _fechaVencimiento;
  String? _monedaSeleccionada;
  bool _fechaInvalida = false;
  bool _isLoading = false;
  int _currentStep = 0;

  final List<Map<String, dynamic>> _opcionesMoneda = [
    {'symbol': '₡', 'name': 'Colones', 'color': Color(0xFF26A17B)},
    {'symbol': '\$', 'name': 'Dólares', 'color': Color(0xFF00D4FF)},
    {'symbol': 'Ξ', 'name': 'Ethereum', 'color': Color(0xFF627EEA)},
    {'symbol': '₿', 'name': 'Bitcoin', 'color': Color(0xFFF7931A)},
    {'symbol': '€', 'name': 'Euros', 'color': Color(0xFF003399)},
  ];

  @override
  void initState() {
    super.initState();
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

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _montoController.dispose();
    _descripcionController.dispose();
    _condicionesController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        final colors = Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: colors.accentBlue,
              surface: colors.panelBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaVencimiento = picked;
        _fechaInvalida = false;
        _currentStep = 1;
      });
      _animateStepCompletion();
    }
  }

  void _animateStepCompletion() {
    _scaleController.reset();
    _scaleController.forward();
  }

  void _goToNextStep() async {
    HapticFeedback.mediumImpact();
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasDate = _fechaVencimiento != null;
    setState(() => _fechaInvalida = !hasDate);

    if (!isFormValid || !hasDate) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isLoading = true);

    // Simular carga
    await Future.delayed(const Duration(milliseconds: 1500));

    final draft = AgreementDraft(
      monto: double.parse(_montoController.text.trim()),
      moneda: _monedaSeleccionada!,
      descripcion: _descripcionController.text.trim(),
      condiciones: _condicionesController.text.trim(),
      vencimiento: _fechaVencimiento!,
      party1: 'CURRENT_USER_WALLET_ADDRESS',
      party2: '',
    );

    setState(() => _isLoading = false);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateSelectUserPage(draft: draft),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Widget _buildAnimatedFormField({
    required Widget child,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(
            0,
            _slideAnimation.value.dy * (index + 1) * 20,
          ),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 4,
              decoration: BoxDecoration(
                color: _currentStep >= 0 ? colors.accentBlue : colors.borderGlow,
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
                color: _currentStep >= 1 ? colors.accentBlue : colors.borderGlow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDropdown() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      decoration: BoxDecoration(
        color: colors.panelBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderGlow, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Tipo de moneda",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: colors.textSecondary),
        ),
        value: _monedaSeleccionada,
        dropdownColor: colors.panelBackground,
        onChanged: (v) {
          HapticFeedback.selectionClick();
          setState(() => _monedaSeleccionada = v);
        },
        items: _opcionesMoneda.map<DropdownMenuItem<String>>((moneda) {
          return DropdownMenuItem<String>(
            value: moneda['symbol'] as String,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: moneda['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      moneda['symbol'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  moneda['name'],
                  style: TextStyle(color: colors.textPrimary),
                ),
              ],
            ),
          );
        }).toList(),
        validator: (v) => v == null ? "Seleccioná una moneda" : null,
      ),
    );
  }

  Widget _buildDateSelector() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.panelBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _fechaInvalida ? Colors.redAccent : colors.borderGlow,
          width: _fechaInvalida ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: colors.accentBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Fecha de vencimiento",
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_fechaVencimiento != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.accentBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: colors.accentBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${_fechaVencimiento!.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(
                      color: colors.accentBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              "Seleccioná la fecha de vencimiento",
              style: TextStyle(
                color: _fechaInvalida ? Colors.redAccent : colors.textSecondary,
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _pickDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.panelBackground,
                foregroundColor: colors.accentBlue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: colors.accentBlue.withOpacity(0.3)),
                ),
              ),
              icon: const Icon(Icons.date_range),
              label: Text(_fechaVencimiento != null ? "Cambiar fecha" : "Seleccionar fecha"),
            ),
          ),
          if (_fechaInvalida)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Debés seleccionar una fecha",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Crear Convenio',
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
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildAnimatedFormField(
                    index: 0,
                    child: BreadcrumbWidget(
                      items: ['Inicio', 'Convenios', 'Crear'],
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
                  
                  const SizedBox(height: 8),
                  
                  _buildAnimatedFormField(
                    index: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.panelBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.borderGlow, width: 1),
                      ),
                      child: TextFormField(
                        controller: _montoController,
                        decoration: InputDecoration(
                          labelText: "Monto acordado",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.attach_money, color: colors.accentBlue),
                          labelStyle: TextStyle(color: colors.textSecondary),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: colors.textPrimary),
                        validator: (v) => validatePositiveNumber(v, fieldName: "Monto"),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() => _currentStep = 0);
                          }
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildAnimatedFormField(
                    index: 2,
                    child: _buildEnhancedDropdown(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildAnimatedFormField(
                    index: 3,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.panelBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.borderGlow, width: 1),
                      ),
                      child: TextFormField(
                        controller: _descripcionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Descripción del convenio",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.description, color: colors.accentBlue),
                          labelStyle: TextStyle(color: colors.textSecondary),
                        ),
                        style: TextStyle(color: colors.textPrimary),
                        validator: (v) => (v == null || v.isEmpty) ? "Este campo es obligatorio" : null,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildAnimatedFormField(
                    index: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.panelBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.borderGlow, width: 1),
                      ),
                      child: TextFormField(
                        controller: _condicionesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Condiciones adicionales",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.rule, color: colors.accentBlue),
                          labelStyle: TextStyle(color: colors.textSecondary),
                        ),
                        style: TextStyle(color: colors.textPrimary),
                        validator: (v) => (v == null || v.isEmpty) ? "Este campo es obligatorio" : null,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildAnimatedFormField(
                    index: 5,
                    child: _buildDateSelector(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: colors.buttonSlideToSwap,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colors.accentBlue.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _goToNextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(colors.accentBlue),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Siguiente",
                                    style: TextStyle(
                                      color: colors.accentBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: colors.accentBlue,
                                    size: 20,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
