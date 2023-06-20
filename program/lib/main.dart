import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/umkm/usahaku/usahaku.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myapp/authentication/login copy.dart';
import 'package:myapp/authentication/register copy.dart';
import 'package:myapp/investor/beranda/beranda.dart';
import 'package:myapp/investor/beranda/notification_page.dart';
import 'package:myapp/investor/beranda/tarikdana_page.dart';
import 'package:myapp/investor/beranda/topup_page.dart';
import 'package:myapp/investor/marketplace/marketplace_page.dart';
import 'package:myapp/investor/marketplace/detail_marketplace.dart';
import 'package:myapp/investor/portofolio/detail_portofolio.dart';
import 'package:myapp/investor/portofolio/portofolio_page.dart';
import 'package:myapp/investor/profil/edit_profil.dart';
import 'package:myapp/investor/profil/profil_page.dart';
import 'package:myapp/investor/profil/pusatbantuan_page.dart';

import 'package:myapp/umkm/beranda/beranda.dart';
import 'package:myapp/umkm/profil/edit_profilUmkm.dart';
import 'package:myapp/umkm/profil/profilUmkm.dart';
import 'package:myapp/umkm/usahaku/pinjaman_aktif.dart';
import 'package:myapp/umkm/usahaku/pinjaman_belum_lunas.dart';
import 'package:myapp/umkm/usahaku/pinjaman_lunas.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/beranda': (context) => HomePage(),
        '/notification': (context) => NotificationPage(),
        '/topup': (context) => TopUpPage(),
        '/tarikdana': (context) => TarikDanaPage(),
        '/marketplace': (context) => MarketplacePage(),
        '/detail-marketplace': (context) => DetailMarketplacePage(),
        '/portofolio': (context) => PortofolioPage(),
        '/profil': (context) => ProfilPage(),
        '/register': (context) => RoleSelectionPage(),
        '/register/akun': (context) => RegisterPage(),
        '/detail-portofolio': (context) => DetailPortofolioPage(),
        '/pusatbantuan': (context) => const PusatBantuanPage(),
        '/edit_profil': (context) => EditProfilePage(),
        // BAGIAN UMKM
        '/berandaUMKM': (context) => HomePageUMKM(),
        '/usahaku': (context) => UsahakuPage(),
        '/pinjaman_belum_lunas': (context) => PinjamanBelumLunas(),
        '/pinjaman_lunas': (context) => PinjamanLunas(),
        '/pinjaman_aktif': (context) => PinjamanAktif(),
        '/profilUmkm': (context) => ProfilUmkmPage(),
        '/edit_profilUmkm': (context) => EditProfileUmkmPage(),
      },
    ));
