import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_dropdown_search.dart';
import '../../../shared/widgets/breadcrumb_widget.dart';
import '../../../home/custom_app_bar.dart';
import '../../domains/user_model.dart';
import 'review_agreement_page.dart';
import '../../domains/convenio_model.dart';

class CreateSelectUserPage extends StatefulWidget {
  final void Function(UserModel selectedUser) onUserConfirmed;

  const CreateSelectUserPage({super.key, required this.onUserConfirmed});

  @override
  State<CreateSelectUserPage> createState() => _CreateSelectUserPageState();
}

class _CreateSelectUserPageState extends State<CreateSelectUserPage> {
  final TextEditingController _searchController = TextEditingController();
  UserModel? _selectedUser;

  void _confirmUser() {
    if (_selectedUser != null) {
      // Simulación del convenio cargado previamente (ajustá según tu flujo real)
      final convenioSimulado = ConvenioModel(
        id: 'temp-id',
        timestamp: DateTime.now(),
        monto: 1500,
        moneda: '₡',
        descripcion: 'Acuerdo de prueba',
        condiciones: 'Condiciones básicas del acuerdo.',
        vencimiento: DateTime.now().add(const Duration(days: 30)),
        firmas: [],
        hash: '0xFAKEHASH1234',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ReviewAgreementPage(
                convenio: convenioSimulado,
                usuario: _selectedUser!,
                onConfirmed: () {
                  // Aquí colocás la acción posterior al slide final
                  print("Contrato firmado y confirmado");
                },
              ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
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
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(color: colors.panelBackground),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CustomAppBar(controller: _searchController),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBreadcrumb(context, colors),
                const SizedBox(height: 16),
                UserDropdownSearch(
                  onUserSelected: (user) {
                    setState(() {
                      _selectedUser = user;
                    });
                  },
                ),
                const SizedBox(height: 24),
                if (_selectedUser != null)
                  _buildUserInfo(_selectedUser!, colors),
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
                          backgroundColor: colors.accentBlue,
                          foregroundColor: Colors.black,
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
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context, AppColorScheme colors) {
    return BreadcrumbWidget(
      items: ['Inicio', 'Convenios', 'Seleccionar Usuario'],
      colors: colors,
      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (index == 1) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildUserInfo(UserModel user, AppColorScheme colors) {
    return Card(
      color: colors.panelBackground,
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre: ${user.firstName ?? ''} ${user.lastName ?? ''}"),
            Text("Username: ${user.username ?? ''}"),
            Text("Email: ${user.email ?? ''}"),
            Text("Estado: ${user.status?.name.toUpperCase() ?? 'N/A'}"),
          ],
        ),
      ),
    );
  }
}
