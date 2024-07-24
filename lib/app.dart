import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/chat.dart';
import 'package:untitled2/login.dart';

class AppProvider extends StatefulWidget {
  final SharedPreferences preferences;

  const AppProvider({super.key, required this.preferences});

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
   String? login;
   String? name;

  @override
  void initState() {
    super.initState();
    read();
  }

  read() {
    login = widget.preferences.getString("login") ?? "";
    name = widget.preferences.getString("name") ?? "";
    print("---------->${login}");
    print("---------->${name}");
  }

  @override
  Widget build(BuildContext context) {

    return login != ""
        ? ChatPage(
            prefLogin: login??"",
            name: name??"",
            preferences: widget.preferences,
          )
        : LoginPage(
            preferences: widget.preferences,
          );
  }
}
