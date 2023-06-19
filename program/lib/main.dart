import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        '/berandaUMKM': (context) => HomePageUMKM(),
      },
    ));
