import 'package:sa_registro_ponto/view/home_view.dart';
import 'package:sa_registro_ponto/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async{
  //garante o carregamento dos widgets
  WidgetsFlutterBinding.ensureInitialized();

  //conecta com o firebase usando as opções do seu projeto
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Registro de Ponto",
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: AuthStream(),
  ));
}


class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return HomeView();
        }
        return LoginView();
      },
      
    );
  }
}