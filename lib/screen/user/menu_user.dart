import 'package:flutter/material.dart';
import 'package:olshop2023/screen/user/home/home_user.dart';
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
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String userid = "", email = "";

  late TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id")!;
      email = preferences.getString("email")!;
    });
    print(userid);
  }

  Future<void> onRefresh() async {
    getPref();
  }

  @override
  void initState() {
    super.initState();
    getPref();
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
                child: const HomeUser(),
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
                      Icons.home,
                      size: 30.0,
                      color: selectIndex == 0 ? const Color.fromARGB(255, 239, 147, 0) : Colors.grey,
                    ),
                    child: Text(
                      'Home',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: selectIndex == 0 ? const Color.fromARGB(255, 239, 147, 0) : Colors.grey),
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
                      Icons.inventory,
                      size: 30.0,
                      color: selectIndex == 1 ? const Color.fromARGB(255, 239, 147, 0) : Colors.grey,
                    ),
                    child: Text(
                      'Invoice',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: selectIndex == 1 ? const Color.fromARGB(255, 239, 147, 0) : Colors.grey),
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
                      Icons.account_circle,
                      size: 30.0,
                      color: selectIndex == 2 ? const Color.fromARGB(255, 239, 147, 0) : Colors.grey,
                    ),
                    child: Text(
                      'Profil',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: selectIndex == 2 ? const Color.fromARGB(255, 239, 147, 0) : Colors.grey),
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
