import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:utkarsh/services/auth.dart';
import 'package:utkarsh/services/ngo_auth.dart';
import 'screens/LandingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider<AuthenticationServices>(
      create: (context) => AuthenticationServices(FirebaseAuth.instance),
    ),
     Provider<NGOAuthServices>(
      create: (context) => NGOAuthServices(FirebaseAuth.instance),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingPage()

        );
  }
}
