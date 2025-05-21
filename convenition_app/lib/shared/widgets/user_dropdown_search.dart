import 'package:flutter/material.dart';
import '../../../convenion/domains/user_model.dart';
import '../../../convenion/services/user_service.dart';

class UserDropdownSearch extends StatefulWidget {
  final void Function(UserModel user) onUserSelected;

  const UserDropdownSearch({super.key, required this.onUserSelected});

  @override
  State<UserDropdownSearch> createState() => _UserDropdownSearchState();
}

class _UserDropdownSearchState extends State<UserDropdownSearch> {
  final UserService _userService = UserService();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  UserModel? _selectedUser;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar usuarios: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Seleccionar Usuario Asociado"),
        const SizedBox(height: 8),
        TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Buscar por nombre o email",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _filteredUsers = _users.where((user) {
                final query = value.toLowerCase();
                return user.username!.toLowerCase().contains(query) ||
                    user.email!.toLowerCase().contains(query);
              }).toList();
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<UserModel>(
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: "Usuario",
            border: OutlineInputBorder(),
          ),
          items: _filteredUsers.map((user) {
            return DropdownMenuItem<UserModel>(
              value: user,
              child: Text("${user.username} (${user.email})"),
            );
          }).toList(),
          onChanged: (user) {
            if (user != null) {
              setState(() => _selectedUser = user);
              widget.onUserSelected(user);
            }
          },
          validator: (value) =>
              value == null ? "Seleccioná un usuario" : null,
        ),
      ],
    );
  }
}
