import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_dropdown_search.dart';
import '../../domains/user_model.dart';

class CreateSelectUserPage extends StatefulWidget {
  final void Function(UserModel selectedUser) onUserConfirmed;

  const CreateSelectUserPage({super.key, required this.onUserConfirmed});

  @override
  State<CreateSelectUserPage> createState() => _CreateSelectUserPageState();
}

class _CreateSelectUserPageState extends State<CreateSelectUserPage> {
  UserModel? _selectedUser;

  void _confirmUser() {
    if (_selectedUser != null) {
      widget.onUserConfirmed(_selectedUser!);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Debés seleccionar un usuario."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Entendido"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Usuario"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserDropdownSearch(
              onUserSelected: (user) {
                setState(() {
                  _selectedUser = user;
                });
              },
            ),
            const SizedBox(height: 24),
            if (_selectedUser != null) _buildUserInfo(_selectedUser!, colors),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentBlue,
                foregroundColor: Colors.black,
              ),
              child: const Text("Confirmar Usuario"),
            ),
          ],
        ),
      ),
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
