import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//model berisi data/state
class ActivityModel {
  String username;
  String password;
  ActivityModel({required this.username, required this.password}); //constructor
}

// Cubit untuk ActivityModel
class ActivityCubit extends Cubit<ActivityModel> {
  String url = "";
  ActivityCubit() : super(ActivityModel(username: "", password: ""));

  // Map dari JSON ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String username = json['username'];
    String password = json['password'];

    // Emit state baru, ini berbeda dengan provider!
    emit(ActivityModel(username: username, password: password));
  }

  void fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Sukses
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}
