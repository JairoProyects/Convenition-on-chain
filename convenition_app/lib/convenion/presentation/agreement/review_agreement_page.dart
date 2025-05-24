import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../../shared/util/notifications.dart'; // showErrorNotification
import '../../domains/convenio_model.dart'; // AgreementDraft
import '../../domains/user_model.dart';
import '../../services/starknet_service.dart';
import './result_agreement_page.dart';

class ReviewAgreementPage extends StatefulWidget {
  final AgreementDraft draft;
  final UserModel usuario;

  const ReviewAgreementPage({
    Key? key,
    required this.draft,
    required this.usuario,
  }) : super(key: key);

  @override
  State<ReviewAgreementPage> createState() => _ReviewAgreementPageState();
}

class _ReviewAgreementPageState extends State<ReviewAgreementPage> {
  bool _isProcessing = false;
  //late final StarknetService _starknetService;

  @override
  void initState() {
    super.initState();
    // Inicializamos el servicio con la cuenta provista
    //_starknetService = StarknetService();
  }

  Future<void> _onConfirm() async {
    setState(() => _isProcessing = true);

    try {
      // Guardamos la acción de navegación para ejecutarla después del modal
      Future<void> navigateToResultPage() async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => AgreementResultPage(
                  draft: widget.draft,
                  usuario: widget.usuario,
                  onChainHash:
                      "txHash", // Reemplazar por el hash real si aplica
                ),
          ),
        );
      }

      // Mostrar el modal y ejecutar la lógica de confirmación (sin navegación aún)
      await showSwapModal(context, () async {
        // Aquí puedes ejecutar la transacción real en el futuro:
        /*
      final txHash = await _starknetService.createConvenio(
        party1: widget.draft.party1,
        party2: widget.draft.party2,
        descripcion: widget.draft.descripcion,
        monto: widget.draft.monto,
        moneda: widget.draft.moneda,
        condiciones: widget.draft.condiciones,
        vencimiento: widget.draft.vencimiento,
      );
      */
      });

      // Navegar después de que el modal se haya cerrado
      await navigateToResultPage();
    } catch (e) {
      // Manejo de errores si aplica
      print("Error al confirmar convenio: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

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
              onTap: (idx) {
                if (idx == 0)
                  Navigator.popUntil(context, (r) => r.isFirst);
                else
                  Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),

            // Datos del convenio
            _buildSection('Datos del Convenio', colors, [
              _dataRow('Descripción', widget.draft.descripcion),
              _dataRow('Condiciones', widget.draft.condiciones),
              _dataRow(
                'Monto',
                '\${widget.draft.moneda} \${widget.draft.monto.toStringAsFixed(2)}',
              ),
              _dataRow(
                'Vencimiento',
                widget.draft.vencimiento.toLocal().toString().split(' ')[0],
              ),
            ]),
            const SizedBox(height: 24),
            // Datos del usuario destinatario
            _buildSection('Usuario Destinatario', colors, [
              _dataRow(
                'Nombre',
                '\${widget.usuario.firstName ?? '
                    '} \${widget.usuario.lastName ?? '
                    '}',
              ),
              _dataRow('Username', widget.usuario.username ?? ''),
              _dataRow('Email', widget.usuario.email ?? ''),
              _dataRow(
                'Estado',
                widget.usuario.status?.name.toUpperCase() ?? '',
              ),
            ]),
            const Spacer(),

            // Botón confirmar
            _isProcessing
                ? CircularProgressIndicator(color: colors.accentBlue)
                : ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.panelBackground,
                    foregroundColor: colors.accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Confirmar Contrato'),
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
          Text(
            '\$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
