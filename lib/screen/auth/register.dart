import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/custom/customButton.dart';
import 'package:olshop2023/network/network.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  final VoidCallback reload;
  const Register(this.reload, {super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final key = GlobalKey<FormState>();
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  cek() {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      submit();
    }
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
      },
    );
    final response = await http.post(
      Uri.parse(
        NetworkURL.register(),
      ),
      body: {
        "nama": namaController.text.trim(),
        "email": emailController.text.trim(),
        "alamat": alamatController.text.trim(),
        "noHp": noHpController.text.trim(),
        "password": passwordController.text.trim(),
      },
    );
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      if (!mounted) return;
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
      if (!mounted) return;
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
  }

  bool isNoHpValid(String noHpController) => noHpController.length == 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          'Registrasi Akun',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: Color.fromARGB(255, 239, 147, 0),
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
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "please insert nama lengkap";
                }
                return null;
              },
              controller: namaController,
              decoration: const InputDecoration(
                hintText: "Nama Lengkap",
                labelText: "Nama ",
                icon: Icon(Icons.person, color: Color.fromARGB(255, 239, 147, 0),),
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !value.contains('@') ||
                    !value.contains('.')) {
                  return 'Invalid Email';
                }
                return null;
              },
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email",
                labelText: "Email ",
                icon: Icon(Icons.email, color: Color.fromARGB(255, 239, 147, 0),),
              ),
            ),
            TextFormField(
              controller: alamatController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Alamat Lengkap",
                labelText: "Alamat Lengkap",
                icon: Icon(Icons.home, color: Color.fromARGB(255, 239, 147, 0),),
              ),
            ),  
            TextFormField(
              validator: (noHpController) {
                if (isNoHpValid(noHpController!)) {
                  return null;
                } else {
                  return 'Enter a valid Handphone/Whatsapp';
                }
              },
              controller: noHpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Handphone/Whatsapp",
                labelText: "Handphone",
                icon: Icon(Icons.phone_android, color: Color.fromARGB(255, 239, 147, 0),),
              ),
              maxLength: 12,
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
                icon: const Icon(Icons.password, color: Color.fromARGB(255, 239, 147, 0),),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                cek();
              },
              child: CustomButton(
                "Buat Akun",
                color: const Color.fromARGB(255, 239, 147, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}