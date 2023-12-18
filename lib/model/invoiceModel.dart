// ignore_for_file: file_names

class InvoiceModel {
  final String id;
  final String invoice;
  final String userid;
  final String mPembayaran;
  final String status;

  InvoiceModel({
    required this.id,
    required this.invoice,
    required this.userid,
    required this.mPembayaran,
    required this.status,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      invoice: json['invoice'],
      userid: json['userid'],
      mPembayaran: json['mPembayaran'],
      status: json['status'],
    );
  }
}
