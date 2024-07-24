
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String prefLogin;
  final String name;
  final SharedPreferences preferences;

  const ChatPage({super.key,
    required this.prefLogin,
    required this.name,
    required this.preferences});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final CollectionReference instance =
  FirebaseFirestore.instance.collection("chats");
  TextEditingController chatController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat "),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: instance.orderBy("date").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                        itemCount: snapshot.data?.size,
                        itemBuilder: (context, index) {
                          DocumentSnapshot? document =
                          snapshot.data?.docs[index];
                          String login = document?['login'] ?? "";
                          return Row(
                            children: [
                          Expanded(
                          child: Visibility(
                          visible: widget.prefLogin != login,
                            child: Container(
                              height: 120,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(
                                      20)),
                              padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(document?['text'])),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("user: "+document?['login']),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                              Expanded(
                                  child: Visibility(
                                    visible: widget.prefLogin == login,
                                    child: Container(
                                      height: 120,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(
                                              20)),
                                      padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(document?['text'])),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("user: "+document?['login']),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Text(snapshot.error.toString());
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue)),
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: chatController,
                      decoration: InputDecoration(hintText: "text"),)),
                    TextButton(onPressed: () {
                      String chatText = chatController.text;
                      if (chatText.isNotEmpty) {
                        try {
                          instance.add(
                              {
                                "login": widget.prefLogin,
                                "text": chatText,
                                "date":DateTime.now()
                              });
                          chatController.clear();
                        } catch (e) {
                          print("Xatolik:${e}");
                        }
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                            Text("Text yozilmagan!")));
                      }
                    }, child: Text("Send"))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
