import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../../shared/util/notifications.dart';
import '../../domains/convenio_model.dart';
import '../../domains/user_model.dart';
import './result_agreement_page.dart';

class ReviewAgreementPage extends StatelessWidget {
  final ConvenioModel convenio;
  final UserModel usuario;
  final VoidCallback? onConfirmed;

  const ReviewAgreementPage({
    super.key,
    required this.convenio,
    required this.usuario,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
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
              color: colors.panelBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: colors.textPrimary,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Revisión del Convenio',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BreadcrumbWidget(
              items: ['Inicio', 'Convenios', 'Revisión Final'],
              colors: colors,
              onTap: (index) {
                if (index == 0) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildSection("Datos del Convenio", colors, [
              _dataRow("Descripción", convenio.descripcion),
              _dataRow("Condiciones", convenio.condiciones),
              _dataRow(
                "Monto",
                "${convenio.moneda} ${convenio.monto.toStringAsFixed(2)}",
              ),
              _dataRow(
                "Vencimiento",
                convenio.vencimiento.toLocal().toString().split(" ")[0],
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection("Usuario Destinatario", colors, [
              _dataRow(
                "Nombre",
                "${usuario.firstName ?? ''} ${usuario.lastName ?? ''}",
              ),
              _dataRow("Username", usuario.username ?? ''),
              _dataRow("Email", usuario.email ?? ''),
              _dataRow("Estado", usuario.status?.name.toUpperCase() ?? ''),
            ]),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.panelBackground,
                      foregroundColor: colors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Volver"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showSwapModal(context, () {
                        // Después de deslizar exitosamente, navegar a recibo
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AgreementResultPage(
                                  convenio: convenio,
                                  usuario: usuario,
                                ),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.panelBackground,
                      foregroundColor: colors.accentBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Confirmar Contrato"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    AppColorScheme colors,
    List<Widget> children,
  ) {
    return Card(
      color: colors.panelBackground,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.heading2(
                colors,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
