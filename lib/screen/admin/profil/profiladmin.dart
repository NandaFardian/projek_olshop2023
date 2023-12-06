import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/custom/customButton.dart';
import 'package:olshop2023/custom/info_card.dart';
import 'package:olshop2023/model/userModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:olshop2023/screen/admin/profil/profil_admin_edit.dart';
import 'package:olshop2023/screen/admin/profil/profil_admin_edit_gambar.dart';
import 'package:olshop2023/screen/admin/profil/profil_detail_admin.dart';
import 'package:olshop2023/screen/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
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

  late String userid;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id")!;
    });
    getProfil();
  }

  var loading = false;
  List<UserModel> list = [];

  getProfil() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(
      Uri.parse(
        NetworkURL.getProfil(userid),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          list.add(UserModel.fromJson(i as Map<String, dynamic>));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
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
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          "Profil Admin",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'roboto',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
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
                            color: const Color.fromARGB(255, 239, 147, 0)
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No',
                        style: TextStyle(color: Color.fromARGB(255, 239, 147, 0)),),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 2,
                            color: const Color.fromARGB(255, 239, 147, 0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          signOut();
                        },
                        child: const Text('Yes',
                        style: TextStyle(color: Color.fromARGB(255, 239, 147, 0)),),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final a = list[i];
                        return Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilDetailAdmin(a, onRefresh),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      '${NetworkURL.server}../imageUser/${a.gambar}',
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilEditGambar(a, onRefresh),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                color: const Color.fromARGB(255, 239, 147, 0),
                              ),
                              Text(
                                a.nama.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MaisonNeue',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 200,
                                child: Divider(
                                  color: Colors.teal.shade700,
                                ),
                              ),
                              InfoCard(
                                text: a.email,
                                icon: Icons.email,
                              ),
                              InfoCard(
                                text: a.alamat,
                                icon: Icons.map,
                              ),
                              InfoCard(
                                text: a.noHp,
                                icon: Icons.phone_iphone,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilEdit(a, onRefresh),
                                    ),
                                  );
                                },
                                child: const CustomButton(
                                  "EDIT PROFIL",
                                  color: Color.fromARGB(255, 239, 147, 0),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
