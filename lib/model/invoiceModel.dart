class InvoiceModel {
  final String? id;
  final String? userid;
  final String? invoice;
  final List<InvoiceDetailModel> detail;

  InvoiceModel({this.id, this.userid, this.invoice, required this.detail});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    var list = json['detail'] as List;
    List<InvoiceDetailModel> dataList =
        list.map((e) => InvoiceDetailModel.fromJson(e)).toList();
    return InvoiceModel(
      id: json['id'],
      invoice: json['invoice'],
      userid: json['userid'],
      detail: dataList,
    );
  }
}

class InvoiceDetailModel {
  final String? id;
  final String? invoice;
  final String? produkid;
  final String? qty;
  final String? harga;
  final String? nmProduk;

  InvoiceDetailModel({
    this.id,
    this.invoice,
    this.produkid,
    this.qty,
    this.harga,
    this.nmProduk,
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailModel(
      id: json['id'],
      invoice: json['invoice'],
      produkid: json['produkid'],
      qty: json['qty'],
      harga: json['harga'],
      nmProduk: json['nmProduk'],
    );
  }
}