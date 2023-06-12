import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActivityProfil {
  String foto;
  String username;
  // constructor
  ActivityProfil({required this.username, required this.foto});
  // create objek CatFact dan isi atributnya dari json 
  factory ActivityProfil.fromJson(Map<String, dynamic> json) {
     return ActivityProfil(
        foto : json['foto'],
        username : json['username'],
     );
  }
}

class ActivityCubit extends Cubit<ActivityProfil> {
  late Future<ActivityProfil> futureProfil; //menampung hasil
  String url = "http://127.0.0.1:8000/";

  ActivityCubit() : super(ActivityProfil(username: "", foto: ""));

  // Map dari JSON ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String foto = json['foto'];
    String username = json['username'];

    // emit
    emit(ActivityProfil(username: username, foto: foto));
  }

  //fetch data
  void fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK artinya berhasil,
      // parse json, return objek CatFact yang terisi
      setFromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal panggil API');
    }
  }

  // void fetchData() async {
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     // Sukses
  //     setFromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Gagal load');
  //   }
  // }
}
