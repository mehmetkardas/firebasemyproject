import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasemyproject/firebase_options.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyProject());
  }
}

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  final String email = "mehmetgskmp31@gmail.com";
  final String password = "pass123456";
  late FirebaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      if (user == null) {
        debugPrint("Kullanıcı oturumu kapatıı");
      } else {
        debugPrint(
          "Kullanıcı oturum açtı ${user.email},email durumu : ${user.emailVerified}",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 55,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  createUserEmailAndPassword();
                },
                child: Text("Kayıt Ol"),
              ),
            ),

            SizedBox(height: 15),

            SizedBox(
              height: 55,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  loginUserEmailAndPassword();
                },
                child: Text("Giriş Yap"),
              ),
            ),

            SizedBox(height: 15),

            SizedBox(
              height: 55,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  signOutUser();
                },
                child: Text("Çıkış Yap"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signOutUser() async {}
}
