import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/auth/login.dart';
import 'package:untitled1/filter.dart';
import 'package:untitled1/homepage.dart';
import 'package:untitled1/test.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();  // ترجع State
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {// هذه الدالة بتفحص هل المستخدم قام بعمل تسجيل دخول او لا
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('=====================User is currently signed out!');
      } else {
        print('=================User is signed in!');
      }
    });
    super.initState();
    print("App started ✅");//هذه اول دالة يتم تنفيذها
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[200],
              titleTextStyle: TextStyle( color: Color(0xFF4e95f4),fontWeight: FontWeight.bold,fontSize: 30.0),
          iconTheme: IconThemeData(size: 20.0,color: Color(0xFF4e95f4))
        )
      ),
      debugShowCheckedModeBanner: false,
       home:
      (FirebaseAuth.instance.currentUser != null  &&
          FirebaseAuth.instance.currentUser!.emailVerified) ? Homepage():Login() //   اذامسجل دخول ومتاكد من تحقق الايميل انقله على صفحة الhomepage واذا لا انقلني هلى ال login
    );
  }
}
