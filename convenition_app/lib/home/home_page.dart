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
  List<ConvenioModel> allConvenios = [];
  List<ConvenioModel> filteredConvenios = [];

  @override
  void initState() {
    super.initState();
    allConvenios = []; // Simulación de convenios
    filteredConvenios = List.from(allConvenios);
  }

  void _searchConvenios(String query) {
    setState(() {
      filteredConvenios = allConvenios
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
                CustomAppBar(
                  controller: _searchController,
                  onSearchChanged: _searchConvenios,
                ),
                const SizedBox(height: 16),
                _buildBreadcrumb(context, colors),
                const SizedBox(height: 12),
                _buildTableHeader(colors),
                const SizedBox(height: 8),
                Expanded(child: _buildConvenioList(colors)),
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
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('Home', style: AppTextStyles.caption(colors)),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text('Convenios', style: AppTextStyles.caption(colors)),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(AppColorScheme colors) {
    return Row(
      children: [
        const SizedBox(width: 32),
        Expanded(child: Text('Item List', style: AppTextStyles.caption(colors))),
        const SizedBox(width: 16),
        Text('Opciones', style: AppTextStyles.caption(colors)),
      ],
    );
  }

  Widget _buildConvenioList(AppColorScheme colors) {
    return ListView.builder(
      itemCount: filteredConvenios.length,
      itemBuilder: (context, index) {
        final convenio = filteredConvenios[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: colors.panelBackground,
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
                        style: AppTextStyles.body(colors).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Participantes: ${convenio.participantes}',
                        style: AppTextStyles.caption(colors),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: colors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }
}
