import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../domains/convenio_model.dart';
import '../../domains/user_model.dart';

class AgreementResultPage extends StatelessWidget {
  final ConvenioModel convenio;
  final UserModel usuario;

  const AgreementResultPage({
    super.key,
    required this.convenio,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final qrData =
        "Convenio: ${convenio.descripcion}\nID: ${convenio.id}\nMonto: ${convenio.moneda}${convenio.monto}\nVence: ${convenio.vencimiento.toLocal().toIso8601String()}";

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
          'Resultado del Convenio',
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("¡Contrato Registrado con Éxito!",
                    style: AppTextStyles.heading2(colors),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                _buildSection("Resumen del Convenio", colors, [
                  // _infoRow("ID", convenio.id),
                  _infoRow("Hash", convenio.onChainHash),
                  _infoRow("Monto", "${convenio.moneda} ${convenio.monto}"),
                  _infoRow("Vencimiento", convenio.vencimiento.toLocal().toString().split(" ")[0]),
                  _infoRow("Descripción", convenio.descripcion),
                  _infoRow("Condiciones", convenio.condiciones),
                ]),
                const SizedBox(height: 24),
                _buildSection("Usuario Asociado", colors, [
                  _infoRow("Nombre", "${usuario.firstName ?? ''} ${usuario.lastName ?? ''}"),
                  _infoRow("Username", usuario.username ?? ''),
                  _infoRow("Email", usuario.email ?? ''),
                ]),
                const SizedBox(height: 24),
                Text("Escaneá o compartí este QR para verificar los datos",
                    style: AppTextStyles.caption(colors),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 180.0,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Share.share(qrData, subject: "Detalles del convenio");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentBlue,
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.share),
                  label: const Text("Compartir"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentBlue,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                  child: const Text("Finalizar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, AppColorScheme colors, List<Widget> content) {
    return Card(
      color: colors.panelBackground,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.heading2(colors).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...content,
          ],
        ),
      ),
    );
  }
}
