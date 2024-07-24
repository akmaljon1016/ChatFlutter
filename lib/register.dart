import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final CollectionReference instance;

  const RegisterPage({super.key, required this.instance});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registratura"),
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
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Ism"),
            ),
            MaterialButton(
              onPressed: () {
                String login = loginController.text;
                String password = passwordController.text;
                String name = nameController.text;
                if (login.isNotEmpty &&
                    password.isNotEmpty &&
                    name.isNotEmpty) {
                  try {
                    widget.instance.add(
                        {"login": login, "password": password, "name": name});
                    Navigator.pop(context);
                  } catch (e) {
                    print("Xatolik:${e}");
                  }
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text("Text mmaydonlar bosh bo'lmasligi kerak!")));
                }
              },
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
