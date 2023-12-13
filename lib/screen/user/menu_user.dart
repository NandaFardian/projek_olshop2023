import 'package:flutter/material.dart';
import 'package:olshop2023/screen/auth/login.dart';
import 'package:olshop2023/screen/user/Produk/produk_user.dart';
import 'package:olshop2023/screen/user/invoice/invoice_user.dart';
import 'package:olshop2023/screen/user/profil/profil_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuUser extends StatefulWidget {
  final VoidCallback signOut;
  const MenuUser(this.signOut, {super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  int selectIndex = 0;
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
      body: Stack(
        children: [
          Offstage(
            offstage: selectIndex != 0,
            child: TickerMode(
              enabled: selectIndex == 0,
              child: const ProdukUser(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 1,
            child: const InvoiceUser(),
          ),
          Offstage(
            offstage: selectIndex != 2,
            child: const ProfilUser(),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: 60,
        height: 60,
        child: Container(
          padding: const EdgeInsets.all(0),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 0;
                  });
                },
                child: Tab(
                  icon: Icon(
                    Icons.apps_outlined,
                    size: 30.0,
                    color: selectIndex == 0
                        ? const Color.fromARGB(255, 239, 147, 0)
                        : Colors.grey,
                  ),
                  child: Text(
                    'Kategori',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: selectIndex == 0
                            ? Color.fromARGB(255, 239, 147, 0)
                            : Colors.grey),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 1;
                  });
                },
                child: Tab(
                  icon: Icon(
                    Icons.assignment_outlined,
                    size: 30.0,
                    color: selectIndex == 1
                        ? const Color.fromARGB(255, 239, 147, 0)
                        : Colors.grey,
                  ),
                  child: Text(
                    'Invoice',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: selectIndex == 1
                            ? Color.fromARGB(255, 239, 147, 0)
                            : Colors.grey),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 2;
                  });
                },
                child: Tab(
                  icon: Icon(
                    Icons.people,
                    size: 30.0,
                    color: selectIndex == 2
                        ? const Color.fromARGB(255, 239, 147, 0)
                        : Colors.grey,
                  ),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: selectIndex == 2
                            ? const Color.fromARGB(255, 239, 147, 0)
                            : Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
