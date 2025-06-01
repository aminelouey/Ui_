// fichier Modifier

import 'package:flutter/material.dart';
import 'package:projet_8016586/splashscreen.dart';
import 'package:window_manager/window_manager.dart';

import 'theme_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // La taille  de la fenêtre
  await Future.delayed(const Duration(milliseconds: 200));
  await windowManager.setSize(const Size(1300, 800));
  await windowManager.setMinimumSize(const Size(1000, 800));
  await windowManager.setResizable(true);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _PatientManagementAppState();
}

class _PatientManagementAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return AnimatedBuilder(
      animation: themeService,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gestion des Patients',
          theme: themeService.themeData,
          home:
              //  HomeScreen(
              //   themeService: themeService,
              // ),
              Splashscreen(
            themeService: themeService,
          ),
        );
      },
    );
  }
}
