import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../home/custom_app_bar.dart';

class ViewAgreementPage extends StatelessWidget {
  const ViewAgreementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> agreements = [
      {
        "title": "Contrato de Servicios",
        "body": "Ambas partes acuerdan los términos de prestación de servicios...",
        "expirationDate": "2025-12-01",
        "signed": true,
        "hash": "0xA1B2C3D4E5F6...",
      },
      {
        "title": "Convenio de colaboración",
        "body": "Compromiso de ambas partes en el desarrollo del proyecto...",
        "expirationDate": "2025-10-15",
        "signed": false,
        "hash": "0xDEADBEEF1234...",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: const CustomAppBar(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundMain,
        ),
        child: SafeArea(
          child: ListView.builder(
            itemCount: agreements.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final agreement = agreements[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.panelBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: AppColors.modalBackground,
                        title: Text(agreement['title'], style: AppTextStyles.heading2),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(agreement['body'], style: AppTextStyles.body),
                            const SizedBox(height: 8),
                            Text("Expira: ${agreement['expirationDate']}", style: AppTextStyles.bodyMuted),
                            Text("Hash: ${agreement['hash']}", style: AppTextStyles.caption),
                            Text(
                              "Estado: ${agreement['signed'] ? 'Firmado por ambas partes' : 'Pendiente de firma'}",
                              style: AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cerrar", style: TextStyle(color: AppColors.accentBlue)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(agreement['title'], style: AppTextStyles.subtitle),
                      const SizedBox(height: 8),
                      Text(
                        agreement['body'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Expira: ${agreement['expirationDate']}",
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hash: ${agreement['hash']}",
                            style: AppTextStyles.caption,
                          ),
                          Icon(
                            agreement['signed']
                                ? Icons.verified_rounded
                                : Icons.pending_actions_rounded,
                            color: agreement['signed']
                                ? AppColors.accentBlue
                                : AppColors.borderGlow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
