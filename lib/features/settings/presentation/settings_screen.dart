import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:squirrel_app/core/auth/domain/entities/auth_token.dart';
import 'package:squirrel_app/core/auth/presentation/bloc/user_bloc.dart';
import 'package:squirrel_app/core/widgets/confirm_dialog.dart';
import 'package:squirrel_app/features/tags/presentation/widgets/tags_section.dart';
import 'package:squirrel_app/features/users/presentation/screens/admin_user_management_screen.dart';
import 'package:squirrel_app/screen_controller.dart';

class SettingsScreen extends StatefulWidget {
  final AuthToken authToken;
  const SettingsScreen({super.key, required this.authToken});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedSettingIndex = 0;

  late final List<(String, Widget)> _settingCategories;

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  _getCategories() {
    _settingCategories = [
      ('Tags', TagsSection(authToken: widget.authToken)),
      if ((context.read<UserBloc>().state as LoggedIn).user.isAdmin)
        ('Users', AdminUserManagementScreen(token: widget.authToken)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final canLogout = await showShadDialog(
                animateIn: [
                  FadeEffect(duration: const Duration(milliseconds: 100)),
                ],
                context: context,
                builder:
                    (context) => ConfirmDialog(
                      title: "Do you want to logout?",
                      description:
                          "You can login again using username and password",
                    ),
              );
              if (canLogout == true && context.mounted) {
                context.read<UserBloc>().add(LogoutEvent());
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ScreenController()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings Navigation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(
                _settingCategories.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Text(_settingCategories[index].$1),
                    selected: _selectedSettingIndex == index,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedSettingIndex = index;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color:
                          _selectedSettingIndex == index
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Add Tag Section
          Expanded(child: _settingCategories[_selectedSettingIndex].$2),
        ],
      ),
    );
  }
}
