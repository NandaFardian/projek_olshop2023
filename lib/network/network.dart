class NetworkURL {
  static String server = "http://192.168.100.228/projek_olshop";

  static String login() {
    return "$server/API/login.php";
  }

  static String register() {
    return "$server/API/register.php";
  }

  static String getProfil(String userid) {
    return "$server/API/profil.php?userid=$userid";
  }

  static String profilEdit() {
    return "$server/API/profilEdit.php";
  }

  static String profilEditGambar() {
    return "$server/API/profilEditGambar.php";
  }

  static String produk() {
    return "$server/API/produk.php";
  }

  static String produkTambah() {
    return "$server/API/produkTambah.php";
  }

  static String produkEdit() {
    return "$server/API/produkEdit.php";
  }

  static String produkHapus() {
    return "$server/API/produkHapus.php";
  }

  static String kategori() {
    return "$server/API/kategori.php";
  }

  static String kategoriTambah() {
    return "$server/API/kategoriTambah.php";
  }
  
  static String kategoriEdit() {
    return "$server/API/kategoriEdit.php";
  }

  static String kategoriHapus() {
    return "$server/API/kategoriHapus.php";
  }

  static String kategoriFilter() {
    return "$server/API/kategoriFilter.php";
  }

  static String invoice() {
    return "$server/API/invoice.php";
  }

  static String invoiceDetail() {
    return "$server/API/invoiceDetail.php";
  }

  static String totalKeranjang(String userid) {
    return "$server/API/totalKeranjang.php?userid=$userid";
  }

  static String tambahKeranjang() {
    return "$server/API/tambahKeranjang.php";
  }

  static String isiKeranjang(String userid) {
    return "$server/API/isiKeranjang.php?userid=$userid";
  }

  static String summaryAmountCart(String userid) {
    return "$server/API/summaryAmountCart.php?userid=$userid";
  }

  static String updateQuantity() {
    return "$server/API/updateQuantity.php";
  }
}

