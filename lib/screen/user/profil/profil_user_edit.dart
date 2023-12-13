import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/model/userModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilUserEdit extends StatefulWidget {
  final UserModel model;
  final VoidCallback reload;
  const ProfilUserEdit(this.model, this.reload, {super.key});

  @override
  State<ProfilUserEdit> createState() => _ProfilUserEditState();
}

class _ProfilUserEditState extends State<ProfilUserEdit> {
  late String userid;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("id")!;
    });
  }

  var cekData = false;
  List<UserModel> list = [];

  late TextEditingController emailController;
  late TextEditingController passwordController;

  setup() {
    emailController = TextEditingController(text: widget.model.email);
    passwordController = TextEditingController(text: widget.model.password);
  }

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  submit() async {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Processing.."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 16,
                ),
                Text("Please wait...")
              ],
            ),
          );
        });

    var url = Uri.parse(NetworkURL.profilEdit());
    var request = http.MultipartRequest("POST", url);
    request.fields['email'] = emailController.text;
    request.fields['password'] = passwordController.text;
    request.fields['userid'] = widget.model.id;
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((a) {
      final data = jsonDecode(a);
      int value = data['value'];
      String message = data['message'];
      if (value == 1) {
        widget.reload();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Information"),
                content: Text(message),
                actions: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        widget.reload();
                      });
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            });
      } else {
        print("Gagal");
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: Text(message),
              actions: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          },
        );
      }
    });
  }

  Future<void> onRefresh() async {
    getPref();
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "please insert email";
                }
                return null;
              },
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "email",
                labelText: "email",
                icon: Icon(Icons.account_circle),
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "please insert password";
                }
                return null;
              },
              obscureText: _secureText,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility),
                ),
                icon: const Icon(Icons.password),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: const Color.fromARGB(255, 239, 147, 0),
              onPressed: () {
                submit();
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
