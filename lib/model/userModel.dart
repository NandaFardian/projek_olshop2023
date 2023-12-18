// ignore_for_file: file_names

class UserModel {
  final String id;
  final String nama;
  final String email;
  final String alamat;
  final String noHp;
  final String password;
  final String level;
  final String gambar;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.noHp,
    required this.password,
    required this.level,
    required this.gambar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      alamat: json['alamat'],
      noHp: json['noHp'],
      password: json['password'],
      level: json['level'], 
      gambar: json['gambar'],
    );
  }
}
