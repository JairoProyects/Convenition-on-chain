import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../convenion/domains/convenio_model.dart';
import 'custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<ConvenioModel> allConvenios = []; // llenado simulado abajo
  List<ConvenioModel> filteredConvenios = [];

  @override
  void initState() {
    super.initState();

    // Simulación de convenios
    allConvenios = [];

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
                CustomAppBar(
                  controller: _searchController,
                  onSearchChanged: _searchConvenios,
                ),
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
                ClipRRect(borderRadius: BorderRadius.circular(8)),
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
