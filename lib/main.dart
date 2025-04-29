import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/pages/login_page.dart';
import 'package:chat_application/pages/register_page.dart';
import 'package:chat_application/services/auth/auth_gate.dart';
import 'package:chat_application/themes/light_mode.dart';
import 'package:chat_application/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      ChangeNotifierProvider(create: (context)=>ThemeProvider(),child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
//used commands
//npm install -g firebase-tools
////flutter pub global activate flutterfire_cli

//in cmd
//dart pub global activate flutterfire_cli
//add system variable "C:\Users\Pooja Solanki\AppData\Local\Pub\Cache\bin"


//flutterfire configure
//flutter pub add firebase_core
//flutter pub add firebase_auth

//flutter pub add provider
