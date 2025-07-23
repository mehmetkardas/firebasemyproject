import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasemyproject/firebase_firestore_kullanimi.dart';
import 'package:firebasemyproject/firebase_options.dart';
import 'package:flutter/foundation.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseFirestoreKullanimi(),
    );
  }
}

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  final String email = "mehmetgskmp31@gmail.com";
  final String password = "yenisifre";
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

            SizedBox(height: 15),

            SizedBox(
              height: 55,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  deleteUser();
                },
                child: Text("Kullanıcı Sil"),
              ),
            ),

            SizedBox(height: 15),

            SizedBox(
              height: 55,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  changePass();
                },
                child: Text("Parola Değiştir"),
              ),
            ),

            SizedBox(height: 15),

            SizedBox(
              height: 55,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  changeEmail();
                },
                child: Text("Email Değiştir"),
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
      var _myUser = _userCredential.user!;
      if (!_myUser.emailVerified) {
        _myUser.sendEmailVerification();
      }
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

  void signOutUser() async {
    try {
      await auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.delete();
    } else {
      debugPrint("Önce oturum açmalısın");
    }
  }

  void changePass() async {
    try {
      await auth.currentUser!.updatePassword("yenisifre");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        debugPrint("Tekrar Oturum Açmalı");
        var credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await auth.currentUser!.updatePassword("yenisifre");
        await auth.signOut();
        debugPrint("Şifre Güncellendi");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void changeEmail() async {
    try {
      await auth.currentUser!.verifyBeforeUpdateEmail("legniga2001@gmail.com");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        var credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        auth.currentUser!.reauthenticateWithCredential(credential);

        await auth.currentUser!.verifyBeforeUpdateEmail(
          "legniga2001@gmail.com",
        );
        await auth.signOut();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
