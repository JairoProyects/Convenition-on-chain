import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_dropdown_search.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../domains/user_model.dart';
import '../../domains/convenio_model.dart';
import './review_agreement_page.dart';

class CreateSelectUserPage extends StatefulWidget {
  final AgreementDraft draft;
  
  const CreateSelectUserPage({
    Key? key,
    required this.draft,
  }) : super(key: key);

  @override
  State<CreateSelectUserPage> createState() => _CreateSelectUserPageState();
}

class _CreateSelectUserPageState extends State<CreateSelectUserPage> {
  UserModel? _selectedUser;

  void _confirmUser() {
    if (_selectedUser == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Debés seleccionar un usuario."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Entendido"),
            ),
          ],
        ),
      );
      return;
    }

    final updatedDraft = AgreementDraft(
      monto: widget.draft.monto,
      moneda: widget.draft.moneda,
      descripcion: widget.draft.descripcion,
      condiciones: widget.draft.condiciones,
      vencimiento: widget.draft.vencimiento,
      party1: widget.draft.party1,
      party2: "",
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewAgreementPage(
          draft: updatedDraft,
          usuario: _selectedUser!
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
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
            decoration: BoxDecoration(color: colors.panelBackground, shape: BoxShape.circle),
            child: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Seleccionar Usuario',
          style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BreadcrumbWidget(
                  items: ['Inicio', 'Convenios', 'Seleccionar Usuario'],
                  colors: colors,
                  onTap: (idx) {
                    if (idx == 0) Navigator.popUntil(context, (r) => r.isFirst);
                    else if (idx == 1) Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),

                Card(
                  color: colors.panelBackground,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monto: ${widget.draft.monto} ${widget.draft.moneda}', style: TextStyle(color: colors.textPrimary)),
                        const SizedBox(height: 6),
                        Text('Descripción: ${widget.draft.descripcion}', style: TextStyle(color: colors.textPrimary)),
                        const SizedBox(height: 6),
                        Text('Condiciones: ${widget.draft.condiciones}', style: TextStyle(color: colors.textPrimary)),
                        const SizedBox(height: 6),
                        Text(
                          'Vencimiento: ${widget.draft.vencimiento.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),

                UserDropdownSearch(
                  onUserSelected: (user) => setState(() => _selectedUser = user),
                ),
                const SizedBox(height: 24),

                if (_selectedUser != null)
                  Card(
                    color: colors.panelBackground,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nombre: ${_selectedUser!.firstName ?? ''} ${_selectedUser!.lastName ?? ''}", style: TextStyle(color: colors.textPrimary)),
                          const SizedBox(height: 6),
                          Text("Username: ${_selectedUser!.username ?? 'N/A'}", style: TextStyle(color: colors.textPrimary)),
                          const SizedBox(height: 6),
                          Text("Email: ${_selectedUser!.email ?? 'N/A'}", style: TextStyle(color: colors.textPrimary)),
                          const SizedBox(height: 6),
                          Text("Estado: ${_selectedUser!.status?.name.toUpperCase() ?? 'N/A'}", style: TextStyle(color: colors.textPrimary)),
                        ],
                      ),
                    ),
                  ),

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
                        onPressed: _confirmUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.panelBackground,
                          foregroundColor: colors.accentBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Siguiente"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
