import 'dart:convert';

import 'package:coincap_app/models/app_config.dart';
import 'package:coincap_app/pages/home_page.dart';
import 'package:coincap_app/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHttpsServices();
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  String configContent = await rootBundle.loadString('assets/config/main.json');

  Map _configMap = jsonDecode(configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: _configMap['COIN_API_BASE_URL']),
  );
}

void registerHttpsServices() {
  GetIt.instance.registerSingleton<HttpsServices>(HttpsServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'coincap',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(80, 60, 197, 1.0),
      ),

      home: HomePage(),
    );
  }
}
