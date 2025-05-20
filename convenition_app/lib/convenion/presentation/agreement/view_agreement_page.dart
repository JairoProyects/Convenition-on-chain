import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../../home/custom_app_bar.dart';

class ViewAgreementPage extends StatefulWidget {
  const ViewAgreementPage({super.key});

  @override
  State<ViewAgreementPage> createState() => _ViewAgreementPageState();
}

class _ViewAgreementPageState extends State<ViewAgreementPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  List<Map<String, dynamic>> agreements = [];

  @override
  void initState() {
    super.initState();
    _fetchAgreements();
  }

  Future<void> _fetchAgreements() async {
    // Simulación: reemplazar con tu service real
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      agreements = []; // Aquí colocarás los datos desde tu backend
      _isLoading = false;
    });
  }

  void _searchAgreements(String query) {
    // Implementa tu lógica si vas a usar búsqueda local
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CustomAppBar(
            controller: _searchController,
            onSearchChanged: _searchAgreements,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BreadcrumbWidget(
                  items: ['Inicio', 'Convenios', 'Ver'],
                  colors: colors,
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else if (index == 1) {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : agreements.isEmpty
                          ? Center(
                            child: Text(
                              "No hay convenios disponibles.",
                              style: AppTextStyles.bodyMuted(colors),
                            ),
                          )
                          : ListView.builder(
                            itemCount: agreements.length,
                            itemBuilder: (context, index) {
                              final agreement = agreements[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.panelBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      agreement['title'] ?? '',
                                      style: AppTextStyles.subtitle(colors),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      agreement['body'] ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodyMuted(colors),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Expira: ${agreement['expirationDate'] ?? ''}",
                                      style: AppTextStyles.caption(colors),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Hash: ${agreement['hash'] ?? ''}",
                                          style: AppTextStyles.caption(colors),
                                        ),
                                        Icon(
                                          (agreement['signed'] ?? false)
                                              ? Icons.verified_rounded
                                              : Icons.pending_actions_rounded,
                                          color:
                                              (agreement['signed'] ?? false)
                                                  ? colors.accentBlue
                                                  : colors.borderGlow,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
