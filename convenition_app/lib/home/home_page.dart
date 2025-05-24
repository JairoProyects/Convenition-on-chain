import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../convenion/domains/convenio_model.dart';
import 'custom_app_bar.dart';
import '../convenion/presentation/agreement/view_agreement_page.dart';
import '../../shared/widgets/breadcrumb_widget.dart';
import '../convenion/services/convenio_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<ConvenioModel> allConvenios = [];
  List<ConvenioModel> filteredConvenios = [];
  Set<int> selectedConvenios = {};

  static const int _itemsPerPage = 5;
  int _currentPage = 0;
  bool _isLoading = true;
  bool _isSearching = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _staggerController;
  late AnimationController _pulseController;
  late AnimationController _statsController;
  late AnimationController _shimmerController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    loadConveniosFromBackend();
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
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _staggerController.forward();
    _statsController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _staggerController.dispose();
    _pulseController.dispose();
    _statsController.dispose();
    _shimmerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadConveniosFromBackend() async {
    try {
      // Simular carga de datos del backend
      await Future.delayed(const Duration(milliseconds: 2000));
      
      final convenios = await ConvenioService().fetchConvenios();
      setState(() {
        allConvenios = convenios;
        filteredConvenios = List.from(convenios);
        _isLoading = false;
      });

      _startAnimations();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error al cargar convenios', isError: true);
    }
  }

  void _searchConvenios(String query) {
    setState(() {
      _currentPage = 0;
      _isSearching = query.isNotEmpty;
      filteredConvenios = allConvenios
          .where((c) =>
              c.descripcion.toLowerCase().contains(query.toLowerCase()) ||
              c.condiciones.toLowerCase().contains(query.toLowerCase()) ||
              c.onChainHash.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(int convenioId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (selectedConvenios.contains(convenioId)) {
        selectedConvenios.remove(convenioId);
      } else {
        selectedConvenios.add(convenioId);
      }
    });
  }

  void _nextPage() {
    if ((_currentPage + 1) * _itemsPerPage < filteredConvenios.length) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentPage--;
      });
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
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildAnimatedWidget({
    required Widget child,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        final itemAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(
              (index * 0.1).clamp(0.0, 1.0),
              ((index * 0.1) + 0.3).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        return Transform.translate(
          offset: Offset(0, (1 - itemAnimation.value) * 50),
          child: Opacity(
            opacity: itemAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect({required Widget child}) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colors.panelBackground,
                colors.borderGlow.withOpacity(0.5),
                colors.panelBackground,
              ],
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // App Bar Skeleton
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: colors.panelBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Header Skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerEffect(
                          child: Container(
                            width: 200,
                            height: 28,
                            decoration: BoxDecoration(
                              color: colors.panelBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildShimmerEffect(
                          child: Container(
                            width: 150,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colors.panelBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildShimmerEffect(
                      child: Container(
                        width: 120,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colors.panelBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Stats Cards Skeleton
                Row(
                  children: List.generate(3, (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                      child: _buildShimmerEffect(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: colors.panelBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 24),
                
                // Action Bar Skeleton
                _buildShimmerEffect(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: colors.panelBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // List Items Skeleton
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildShimmerEffect(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: colors.panelBackground,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Loading Indicator
                Center(
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: colors.accentBlue.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.description,
                                color: colors.accentBlue,
                                size: 30,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando convenios...',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildStatsCards() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final activeCount = allConvenios.where((c) => c.status == "Activo").length;
    final pendingCount = allConvenios.where((c) => c.status == "Pendiente").length;
    final expiredCount = allConvenios.where((c) => c.status == "Vencido").length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Activos',
            activeCount.toString(),
            Icons.check_circle,
            colors.accentGreen,
            colors,
            0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Pendientes',
            pendingCount.toString(),
            Icons.schedule,
            Colors.orange,
            colors,
            1,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Vencidos',
            expiredCount.toString(),
            Icons.error,
            Colors.red,
            colors,
            2,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color accentColor,
    AppColorScheme colors,
    int index,
  ) {
    return _buildAnimatedWidget(
      index: index + 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.panelBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderGlow, width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _statsController,
              builder: (context, child) {
                final animatedValue = (_statsController.value * int.parse(value)).round();
                return Text(
                  animatedValue.toString(),
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return _buildAnimatedWidget(
      index: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Convenios Activos',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${filteredConvenios.length} convenios encontrados',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          BreadcrumbWidget(
            items: ['Inicio', 'Convenios'],
            colors: colors,
            onTap: (index) {
              HapticFeedback.lightImpact();
              if (index == 0) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return _buildAnimatedWidget(
      index: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.panelBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderGlow, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.accentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.list_alt, color: colors.accentBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Lista de Convenios',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (selectedConvenios.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${selectedConvenios.length} seleccionados',
                  style: TextStyle(
                    color: colors.accentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.accentBlue, colors.accentBlue.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ViewAgreementPage(),
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
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                label: const Text(
                  'Ver más',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvenioCard(ConvenioModel convenio, int index) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final isSelected = selectedConvenios.contains(convenio.id);
    final statusColor = convenio.status == "Activo"
        ? colors.accentGreen
        : convenio.status == "Pendiente"
            ? Colors.orange
            : Colors.red;

    return _buildAnimatedWidget(
      index: index + 5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.panelBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.accentBlue : colors.borderGlow,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colors.accentBlue.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showConvenioDetails(convenio),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleSelection(convenio.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? colors.accentBlue : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? colors.accentBlue : colors.borderGlow,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                convenio.descripcion,
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                convenio.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: colors.accentBlue, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${convenio.moneda}${convenio.monto.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.calendar_today, color: colors.textSecondary, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                convenio.vencimiento.toLocal().toString().split(' ')[0],
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: colors.accentBlue,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final totalPages = (filteredConvenios.length / _itemsPerPage).ceil();
    final start = _currentPage * _itemsPerPage + 1;
    final end = ((_currentPage + 1) * _itemsPerPage).clamp(0, filteredConvenios.length);

    return _buildAnimatedWidget(
      index: 10,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.panelBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderGlow, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mostrando $start-$end de ${filteredConvenios.length}',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _currentPage > 0 
                        ? colors.accentBlue.withOpacity(0.1) 
                        : colors.borderGlow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _currentPage > 0 ? _previousPage : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: _currentPage > 0 ? colors.accentBlue : colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Página ${_currentPage + 1} de $totalPages',
                    style: TextStyle(
                      color: colors.accentBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: (_currentPage + 1) < totalPages 
                        ? colors.accentBlue.withOpacity(0.1) 
                        : colors.borderGlow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: (_currentPage + 1) < totalPages ? _nextPage : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: (_currentPage + 1) < totalPages ? colors.accentBlue : colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConvenioDetails(ConvenioModel convenio) async {
    HapticFeedback.lightImpact();
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    try {
      final convenioCompleto = await ConvenioService().fetchConvenioById(convenio.id);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: colors.modalBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.description, color: colors.accentBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Detalles del Convenio',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Descripción', convenioCompleto.descripcion, Icons.text_snippet, colors),
                _buildDetailRow('Condiciones', convenioCompleto.condiciones, Icons.rule, colors),
                _buildDetailRow('Monto', '${convenioCompleto.moneda} ${convenioCompleto.monto}', Icons.attach_money, colors),
                _buildDetailRow('Vencimiento', convenioCompleto.vencimiento.toLocal().toString().split(' ')[0], Icons.calendar_today, colors),
                _buildDetailRow('Estado', convenioCompleto.status, Icons.info, colors),
                _buildDetailRow('Hash', convenioCompleto.onChainHash, Icons.link, colors),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: colors.accentBlue,
                ),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Error al cargar convenio ${convenio.id}', isError: true);
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon, AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    if (_isLoading) return _buildLoadingState();

    final start = _currentPage * _itemsPerPage;
    final end = (_currentPage + 1) * _itemsPerPage;
    final paginatedList = filteredConvenios.sublist(
      start,
      end > filteredConvenios.length ? filteredConvenios.length : end,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomAppBar(
                  controller: _searchController,
                  onSearchChanged: _searchConvenios,
                ),
                const SizedBox(height: 24),
                
                _buildHeader(),
                const SizedBox(height: 24),
                
                _buildStatsCards(),
                const SizedBox(height: 24),
                
                _buildActionBar(),
                const SizedBox(height: 24),
                
                ...paginatedList.asMap().entries.map((entry) {
                  return _buildConvenioCard(entry.value, entry.key);
                }).toList(),
                
                const SizedBox(height: 24),
                _buildPaginationControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
