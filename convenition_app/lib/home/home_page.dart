import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../agreements/domains/convenio_model.dart';
import 'custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Convenio> allConvenios = []; // llenado simulado abajo
  List<Convenio> filteredConvenios = [];

  @override
  void initState() {
    super.initState();

    // Simulación de convenios
    allConvenios = [
      Convenio(
        id: '1',
        timestamp: DateTime.now(),
        monto: 100.0,
        firmado: true,
        participantes: 3,
        hash: 'abc123',
        descripcion: 'Cute Cube Cool',
        condiciones: 'Condición A',
        vencimiento: DateTime.now().add(const Duration(days: 30)),
      ),
      Convenio(
        id: '2',
        timestamp: DateTime.now(),
        monto: 150.0,
        firmado: false,
        participantes: 2,
        hash: 'xyz789',
        descripcion: 'Liquid Wave',
        condiciones: 'Condición B',
        vencimiento: DateTime.now().add(const Duration(days: 60)),
      ),
      // Agrega más si necesitas
    ];

    filteredConvenios = List.from(allConvenios);
  }

  void _searchConvenios(String query) {
    setState(() {
      filteredConvenios =
          allConvenios
              .where(
                (c) =>
                    c.descripcion.toLowerCase().contains(query.toLowerCase()) ||
                    c.condiciones.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundMain),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomAppBar(onSearchChanged: _searchConvenios),
                const SizedBox(height: 16),
                _buildBreadcrumb(context),
                const SizedBox(height: 12),
                _buildTableHeader(),
                const SizedBox(height: 8),
                Expanded(child: _buildConvenioList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Convenios Activos', style: AppTextStyles.heading2),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text('Home', style: AppTextStyles.caption),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 4),
            const Text('Convenios', style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: const [
        SizedBox(width: 32), // espacio para el checkbox
        Expanded(child: Text('Item List', style: AppTextStyles.caption)),
        SizedBox(width: 16),
        Text('Opciones', style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildConvenioList() {
    return ListView.builder(
      itemCount: filteredConvenios.length,
      itemBuilder: (context, index) {
        final convenio = filteredConvenios[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.panelBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convenio.descripcion,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Participantes: ${convenio.participantes}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }
}
