import 'package:flutter/material.dart';
import 'package:project/screens/landingPage.dart';
import "package:project/firebase_options.dart";
import 'package:provider/provider.dart';
import 'notifiers/authNotifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthNotifier(),
      ),
      // ChangeNotifierProvider(
      //   create: (_) => FoodNotifier(),
      // ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Store',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: const Color.fromRGBO(255, 63, 111, 1),
      ),
      home: Scaffold(
        body: LandingPage(),
      ),
    );
  }
}
