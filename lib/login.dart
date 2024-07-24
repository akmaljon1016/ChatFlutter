import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/chat.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/register.dart';

class LoginPage extends StatefulWidget {
  final SharedPreferences preferences;

  const LoginPage({super.key, required this.preferences});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final CollectionReference instance =
      FirebaseFirestore.instance.collection("users");
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "login"),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "password"),
            ),
            MaterialButton(
              onPressed: () {
                String login = loginController.text;
                String password = passwordController.text;
                instance.snapshots().forEach((element) {
                  element.docs.forEach((element) {
                    if (login == element['login'] &&
                        password == element['password']) {
                      widget.preferences.setString("name", element['name']);
                      widget.preferences.setString("login", login);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    prefLogin: login,
                                    name: element['name'],
                                    preferences: preferences,
                                  )));
                    }
                  });
                });
              },
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterPage(
                              instance: instance,
                            )));
              },
              child: Text(
                "Register",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
