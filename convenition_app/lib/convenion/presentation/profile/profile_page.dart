import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';

import '../../services/user_service.dart';
import '../../services/user_profile_service.dart';
import '../../domains/user_model.dart';

class ProfilePage extends StatefulWidget {
  final int  userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserModel> _userFuture;
  final _picker = ImagePicker();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  bool _isEditing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    _userFuture = UserService().getUserById(widget.userId.toString());
    _userFuture.then((user) {
      _firstNameCtrl.text = user.firstName ?? '';
      _lastNameCtrl.text = user.lastName ?? '';
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final file = File(picked.path);
    final resp = await UserProfileService().uploadProfileImage(
      userId: widget.userId,
      imageFile: file,
    );
    // Reload user to get new URL
    setState(() {
      _userFuture = Future.value(
        ( _userFuture ).then((u) => u.copyWith(profileImageUrl: resp.imageUrl))
      );
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    await UserService().updateUser(
      widget.userId,
      UpdateUserDto(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        status: 'activo', // or preserve previous
      ),
    );
    setState(() {
      _isEditing = false;
      _saving = false;
      _loadUser();
    });
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
            decoration: BoxDecoration(
              color: colors.panelBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new,
                color: colors.textPrimary, size: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile',
            style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: colors.accentBlue,
            ),
            onPressed: _isEditing ? _saveProfile : () {
              setState(() => _isEditing = true);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error: \${snap.error}'));
            }
            final user = snap.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: kToolbarHeight + 16, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: colors.panelBackground,
                      backgroundImage: user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : null,
                      child: user.profileImageUrl == null
                          ? Icon(Icons.person, size: 50, color: colors.textSecondary)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user.username ?? '',
                      style: AppTextStyles.heading2(colors)),
                  const SizedBox(height: 8),
                  if (_isEditing)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _firstNameCtrl,
                            decoration: InputDecoration(labelText: 'First Name'),
                          ),
                          TextField(
                            controller: _lastNameCtrl,
                            decoration: InputDecoration(labelText: 'Last Name'),
                          ),
                          const SizedBox(height: 16),
                          if (_saving) const CircularProgressIndicator(),
                        ],
                      ),
                    )
                  else ...[
                    Text('${user.firstName ?? ''} ${user.lastName ?? ''}',
                        style: AppTextStyles.body(colors)),
                    const SizedBox(height: 4),
                    Text(user.email ?? '',
                        style: TextStyle(fontSize: 14, color: colors.textSecondary)),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
