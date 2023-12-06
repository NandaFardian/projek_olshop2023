import 'package:flutter/material.dart';
import 'package:olshop2023/screen/admin/invoice/invoice_admin.dart';
import 'package:olshop2023/screen/admin/kategori/kategori_admin.dart';
import 'package:olshop2023/screen/admin/produk/produk_admin.dart';
import 'package:olshop2023/screen/admin/profil/profiladmin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuAdmin extends StatefulWidget {
  final VoidCallback signOut;
  const MenuAdmin(this.signOut, {super.key});

  @override
  State<MenuAdmin> createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
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
              child: const KategoriAdmin(),
            ),
          ),
          Offstage(
            offstage: selectIndex != 1,
            child: const ProdukAdmin(),
          ),
          Offstage(
            offstage: selectIndex != 2,
            child: const InvoiceAdmin(),
          ),
          Offstage(
            offstage: selectIndex != 3,
            child: const ProfilAdmin(),
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
                    Icons.add_shopping_cart_outlined,
                    size: 30.0,
                    color: selectIndex == 1
                        ? const Color.fromARGB(255, 239, 147, 0)
                        : Colors.grey,
                  ),
                  child: Text(
                    'Produk',
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
                    Icons.assignment_outlined,
                    size: 30.0,
                    color: selectIndex == 2
                        ? const Color.fromARGB(255, 239, 147, 0)
                        : Colors.grey,
                  ),
                  child: Text(
                    'Invoice',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: selectIndex == 2
                            ? const Color.fromARGB(255, 239, 147, 0)
                            : Colors.grey),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectIndex = 3;
                  });
                },
                child: Tab(
                  icon: Icon(
                    Icons.person,
                    size: 30.0,
                    color: selectIndex == 3
                        ? const Color.fromARGB(255, 239, 147, 0)
                        : Colors.grey,
                  ),
                  child: Text(
                    'Profil',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: selectIndex == 3
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
