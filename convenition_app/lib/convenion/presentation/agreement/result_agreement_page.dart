import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../domains/user_model.dart';
import '../../domains/convenio_model.dart';
import '../../services/convenio_service.dart';

class AgreementResultPage extends StatefulWidget {
  final AgreementDraft draft;
  final UserModel usuario;
  final String onChainHash;

  const AgreementResultPage({
    Key? key,
    required this.draft,
    required this.usuario,
    required this.onChainHash,
  }) : super(key: key);

  @override
  State<AgreementResultPage> createState() => _AgreementResultPageState();
}

class _AgreementResultPageState extends State<AgreementResultPage> {
  late ConvenioModel? convenio;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _createConvenio();
  }

  Future<void> _createConvenio() async {
    try {
      final dto = CreateConvenioDto(
        monto: widget.draft.monto,
        moneda: widget.draft.moneda,
        descripcion: widget.draft.descripcion,
        condiciones: widget.draft.condiciones,
        vencimiento: widget.draft.vencimiento,
        firmas: [widget.draft.party1, widget.draft.party2],
        onChainHash: widget.onChainHash,
      );

      final created = await ConvenioService().createConvenio(dto);

      setState(() {
        convenio = created;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    if (_loading) {
      return Scaffold(
        backgroundColor: colors.backgroundMain.colors.first,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: colors.backgroundMain.colors.first,
        body: Center(
          child: Text('Error: $_error', style: TextStyle(color: colors.textPrimary)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Contrato Confirmado', style: TextStyle(color: colors.textPrimary)),
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.textPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: colors.textPrimary),
            onPressed: () {
              Share.share(_buildQrData().trim());
            },
            tooltip: 'Compartir Convenio',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("¡Convenio creado exitosamente!", style: AppTextStyles.heading1(colors)),
              const SizedBox(height: 16),

              Text("Hash On-Chain:", style: AppTextStyles.heading2(colors)),
              SelectableText(widget.onChainHash, style: TextStyle(color: colors.accentBlue)),

              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    Text(
                      "Escaneá este código QR para compartir el convenio",
                      style: AppTextStyles.heading2(colors),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    QrImageView(
                      data: _buildQrData(),
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _infoTile("Descripción", widget.draft.descripcion),
              _infoTile("Condiciones", widget.draft.condiciones),
              _infoTile("Monto", "${widget.draft.moneda} ${widget.draft.monto.toStringAsFixed(2)}"),
              _infoTile("Vencimiento", widget.draft.vencimiento.toLocal().toString().split(' ')[0]),
              _infoTile("Destinatario", "${widget.usuario.firstName} ${widget.usuario.lastName}"),
              _infoTile("Correo", widget.usuario.email ?? 'N/A'),

              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Volver al Inicio"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildQrData() {
    return '''
    Descripción: ${widget.draft.descripcion}
    Condiciones: ${widget.draft.condiciones}
    Monto: ${widget.draft.moneda} ${widget.draft.monto.toStringAsFixed(2)}
    Vencimiento: ${widget.draft.vencimiento.toLocal().toString().split(' ')[0]}
    Destinatario: ${widget.usuario.firstName} ${widget.usuario.lastName}
    Correo: ${widget.usuario.email ?? 'N/A'}
    Hash On-Chain: ${widget.onChainHash}
    ''';
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value),
        ],
      ),
    );
  }
}
