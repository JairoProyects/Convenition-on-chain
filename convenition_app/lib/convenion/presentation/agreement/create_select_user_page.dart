import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_dropdown_search.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../domains/user_model.dart';
import '../../domains/convenio_model.dart'; // Aquí está AgreementDraft

class CreateSelectUserPage extends StatefulWidget {
  final AgreementDraft draft;
  final void Function(UserModel selectedUser, AgreementDraft updatedDraft) onUserConfirmed;

  const CreateSelectUserPage({
    super.key,
    required this.draft,
    required this.onUserConfirmed,
  });

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

    // Creamos un nuevo draft incluyendo party2 con la wallet del usuario
    final updatedDraft = AgreementDraft(
      monto: widget.draft.monto,
      moneda: widget.draft.moneda,
      descripcion: widget.draft.descripcion,
      condiciones: widget.draft.condiciones,
      vencimiento: widget.draft.vencimiento,
      party1: widget.draft.party1,
      // party2: _selectedUser!.walletAddress,
      party2: '',
    );

    // Llamamos al callback, que se encargará de la navegación
    widget.onUserConfirmed(_selectedUser!, updatedDraft);
  }

  void _goBack() => Navigator.pop(context);

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
          onPressed: _goBack,
        ),
        title: Text(
          'Seleccionar Usuario para Contrato',
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BreadcrumbWidget(
                  items: ['Inicio', 'Convenios', 'Seleccionar Usuario'],
                  colors: colors,
                  onTap: (idx) {
                    if (idx == 0) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else if (idx == 1) {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 16),
                UserDropdownSearch(
                  onUserSelected: (user) {
                    setState(() => _selectedUser = user);
                  },
                ),
                const SizedBox(height: 24),
                if (_selectedUser != null) ...[
                  Card(
                    color: colors.panelBackground,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nombre: ${_selectedUser!.firstName ?? ''} ${_selectedUser!.lastName ?? ''}"),
                          Text("Username: ${_selectedUser!.username ?? 'N/A'}"),
                          Text("Email: ${_selectedUser!.email ?? 'N/A'}"),
                          Text("Estado: ${_selectedUser!.status?.name.toUpperCase() ?? 'N/A'}"),
                        ],
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _goBack,
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

