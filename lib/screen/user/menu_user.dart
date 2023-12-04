import 'package:flutter/material.dart';
import 'package:olshop2023/screen/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuUser extends StatefulWidget {
  final VoidCallback signOut;
  const MenuUser(this.signOut, {super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value") ?? 0;
    pref.setString("level", "");
    pref.remove("id");
    pref.remove("email");
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Admin",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'roboto',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 247, 92, 20),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Warning"),
                    content: const Text("Apakah Anda Yakin Inggin Keluar?"),
                    actions: <Widget>[
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 2,
                            color: const Color.fromARGB(255, 247, 92, 20)
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No',
                        style: TextStyle(color: Color.fromARGB(255, 247, 92, 20)),),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 2,
                            color: const Color.fromARGB(255, 247, 92, 20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          signOut();
                        },
                        child: const Text('Yes',
                        style: TextStyle(color: Color.fromARGB(255, 247, 92, 20)),),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
