import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/model/produkModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:olshop2023/screen/user/home/home_user_detail_gambar.dart';

class HomeUserDetail extends StatefulWidget {
  final ProdukModel model;
  const HomeUserDetail(this.model,{super.key});

  @override
  State<HomeUserDetail> createState() => _HomeUserDetailState();
}

final price = NumberFormat("#,##0", 'en_US');

class _HomeUserDetailState extends State<HomeUserDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: Text(
          widget.model.nama!,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'roboto',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeUserDetailGambar(widget.model),
                        ),
                      );
                    },
                    child: Image.network(
                      "${NetworkURL.server}../imageProduk/${widget.model.gambar}",
                      fit: BoxFit.fill,
                      height: 300,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "List Keterangan :",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Source Sans Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.model.keterangan!,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Source Sans Pro',
                  ),  
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Divider(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox (
                  height: 180,),

                InkWell(
                  onTap: () {

                  },
                  child: Container(
                            margin: const EdgeInsets.only(right: 8, left: 250),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 239, 147, 0)),
                            child: const Center(
                              child: Text("Add To Cart", style: TextStyle(color: Colors.white),),
                            ),
                          ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
