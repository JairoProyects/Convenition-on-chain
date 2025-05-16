import 'package:flutter/material.dart';

class ViewAgreementPage extends StatelessWidget {
  const ViewAgreementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulación de acuerdos firmados
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
      appBar: AppBar(title: const Text("Convenios firmados")),
      body: ListView.builder(
        itemCount: agreements.length,
        itemBuilder: (context, index) {
          final agreement = agreements[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(agreement['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(agreement['body'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("Expira: ${agreement['expirationDate']}"),
                  const SizedBox(height: 4),
                  Text("Hash: ${agreement['hash']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              trailing: Icon(
                agreement['signed'] ? Icons.verified_rounded : Icons.pending_actions_rounded,
                color: agreement['signed'] ? Colors.green : Colors.orange,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(agreement['title']),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(agreement['body']),
                        const SizedBox(height: 8),
                        Text("Expira: ${agreement['expirationDate']}"),
                        Text("Hash: ${agreement['hash']}"),
                        Text("Estado: ${agreement['signed'] ? 'Firmado por ambas partes' : 'Pendiente de firma'}"),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar"))
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
