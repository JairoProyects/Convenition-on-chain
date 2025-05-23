import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../convenion/domains/convenio_model.dart';
import 'custom_app_bar.dart';
import '../convenion/presentation/agreement/view_agreement_page.dart';
import '../../shared/widgets/breadcrumb_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<ConvenioModel> allConvenios = [];
  List<ConvenioModel> filteredConvenios = [];

  static const int _itemsPerPage = 5;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Simulación de convenios con nuevo modelo actualizado
    allConvenios = List.generate(
      10,
      (index) => ConvenioModel(
        id: "$index",
        externalId: "external-$index",
        timestamp: DateTime.now(),
        monto: 1000.0 + index,
        moneda: index % 2 == 0 ? '₡' : 'Ξ',
        onChainHash: "0xHASH$index",
        descripcion: "Convenio $index",
        condiciones: "Condiciones del convenio número $index",
        vencimiento: DateTime.now().add(const Duration(days: 30)),
        firmas: [],
      ),
    );

    filteredConvenios = List.from(allConvenios);
  }

  void _searchConvenios(String query) {
    setState(() {
      _currentPage = 0;
      filteredConvenios = allConvenios
          .where((c) =>
              c.descripcion.toLowerCase().contains(query.toLowerCase()) ||
              c.condiciones.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _nextPage() {
    if ((_currentPage + 1) * _itemsPerPage < filteredConvenios.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark ? AppColors.dark : AppColors.light;

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomAppBar(
                  controller: _searchController,
                  onSearchChanged: _searchConvenios,
                ),
                const SizedBox(height: 16),
                _buildBreadcrumb(context, colors),
                const SizedBox(height: 12),
                _buildTableHeader(colors),
                const SizedBox(height: 8),
                Expanded(child: _buildConvenioList(paginatedList, colors)),
                const SizedBox(height: 12),
                _buildPaginationControls(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context, AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Convenios Activos', style: AppTextStyles.heading2(colors)),
        BreadcrumbWidget(
          items: ['Inicio', 'Convenios'],
          colors: colors,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTableHeader(AppColorScheme colors) {
    return Row(
      children: [
        const SizedBox(width: 32),
        Expanded(
          child: Text('Lista de Convenios', style: AppTextStyles.caption(colors)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewAgreementPage()),
            );
          },
          child: Text(
            'Ver más',
            style: AppTextStyles.caption(colors).copyWith(
              color: colors.accentBlue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvenioList(List<ConvenioModel> list, AppColorScheme colors) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final convenio = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.panelBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(value: false, onChanged: (_) {}),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      convenio.descripcion,
                      style: AppTextStyles.body(colors).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monto: ${convenio.moneda}${convenio.monto.toStringAsFixed(2)}',
                      style: AppTextStyles.caption(colors),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Expira: ${convenio.vencimiento.toLocal().toString().split(' ')[0]}',
                      style: AppTextStyles.caption(colors),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Aquí puede ir navegación a detalle
                },
                child: Text(
                  "Ver más",
                  style: TextStyle(color: colors.accentBlue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(AppColorScheme colors) {
    final totalPages = (filteredConvenios.length / _itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: _currentPage > 0 ? colors.accentBlue : colors.textSecondary,
          onPressed: _previousPage,
        ),
        Text(
          'Página ${_currentPage + 1} de $totalPages',
          style: AppTextStyles.caption(colors),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color:
              (_currentPage + 1) < totalPages ? colors.accentBlue : colors.textSecondary,
          onPressed: _nextPage,
        ),
      ],
    );
  }
}
