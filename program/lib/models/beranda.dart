// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:decimal/decimal.dart';

// //model berisi data/state
// class ListUMKMBerandaPendana {
//   String nama_umkm;
//   Decimal sisa_pokok;

//   ListUMKMBerandaPendana({required this.nama_umkm, required this.sisa_pokok});
// }

// class ActivityModel {
//   String nama_pendana;
//   Decimal saldo;
//   Decimal total_pendanaan;
//   Decimal total_bagi_hasil;
//   int jumlah_didanai_aktif;
//   List<ListUMKMBerandaPendana> umkm;

//   ActivityModel({
//     required this.nama_pendana,
//     required this.saldo,
//     required this.total_pendanaan,
//     required this.total_bagi_hasil,
//     required this.jumlah_didanai_aktif,
//     required this.umkm,
//   });
// }

// class ActivityCubit extends Cubit<ActivityModel> {
//   String url = "";

//   ActivityCubit()
//       : super(ActivityModel(
//           nama_pendana: "",
//           saldo: Decimal.zero,
//           total_pendanaan: Decimal.zero,
//           total_bagi_hasil: Decimal.zero,
//           jumlah_didanai_aktif: 0,
//           umkm: [],
//         ));

//   // Map dari JSON ke atribut
//   void setFromJson(Map<String, dynamic> json) {
//     String nama_pendana = json['nama_pendana'];
//     Decimal saldo = Decimal.parse(json['saldo']);
//     Decimal total_pendanaan = Decimal.parse(json['total_pendanaan']);
//     Decimal total_bagi_hasil = Decimal.parse(json['total_bagi_hasil']);
//     int jumlah_didanai_aktif = json['jumlah_didanai_aktif'];
//     List<dynamic> umkmData = json['umkm'];
//     List<ListUMKMBerandaPendana> umkm = [];

//     // Mengkonversi data umkm dari JSON ke objek ListUMKMBerandaPendana
//     for (var item in umkmData) {
//       String nama_umkm = item['nama_umkm'];
//       Decimal sisa_pokok = Decimal.parse(item['sisa_pokok']);
//       umkm.add(ListUMKMBerandaPendana(
//         nama_umkm: nama_umkm,
//         sisa_pokok: sisa_pokok,
//       ));
//     }

//     // Emit state baru
//     emit(ActivityModel(
//       nama_pendana: nama_pendana,
//       saldo: saldo,
//       total_pendanaan: total_pendanaan,
//       total_bagi_hasil: total_bagi_hasil,
//       jumlah_didanai_aktif: jumlah_didanai_aktif,
//       umkm: umkm,
//     ));
//   }

//   Future<void> fetchData() async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       // Sukses
//       setFromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Gagal load');
//     }
//   }
// }
