// ignore_for_file: file_names

class InvoiceDetailModel {
  final String id;
  final String invoiceid;
  final String produkid;
  final String qty;
  final String total;

  InvoiceDetailModel({
    required this.id,
    required this.invoiceid,
    required this.produkid,
    required this.qty,
    required this.total,
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDetailModel(
      id: json['id'],
      invoiceid: json['invoiceid'],
      produkid: json['produkid'],
      qty: json['qty'],
      total: json['total'],
    );
  }
}
