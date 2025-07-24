import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreKullanimi extends StatefulWidget {
  const FirebaseFirestoreKullanimi({super.key});

  @override
  State<FirebaseFirestoreKullanimi> createState() =>
      _FirebaseFirestoreKullanimiState();
}

class _FirebaseFirestoreKullanimiState
    extends State<FirebaseFirestoreKullanimi> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase FireStore"),
        backgroundColor: Colors.orange,
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
                  veriEkleAdd();
                },
                child: Text("Add ile veri ekle"),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  veriEkleSet();
                },
                child: Text("Set ile veri ekle"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void veriEkleAdd() async {
    Map<String, dynamic> _ekleneceklerUser = {};
    _ekleneceklerUser["name"] = "Ahmet";
    _ekleneceklerUser["age"] = 25;
    _ekleneceklerUser["isStudent"] = "false";
    _ekleneceklerUser["adress"] = {
      "city": "Edirne",
      "district": "Havsa",
      "street": "Yeni",
    };
    _ekleneceklerUser["colors"] = FieldValue.arrayUnion(["kırmızı", "beyaz"]);

    await firestore.collection("users").add(_ekleneceklerUser);
  }

  void veriEkleSet() async {
    /* await firestore.doc("users/jmjsqADcA7gxjIbs6SSs").set({
      "okul": "Marmara Üniversitesi",
    }, SetOptions(merge: true));*/

    var yeniDocId = firestore.collection("users").doc().id;
    Map<String, dynamic> _ekleneceklerUser = {};
    _ekleneceklerUser["userID"] = yeniDocId;
    _ekleneceklerUser["name"] = "İcardi";
    _ekleneceklerUser["age"] = 31;
    _ekleneceklerUser["school"] = "California Universty";
    _ekleneceklerUser["adress"] = {
      "city": "Argentina",
      "district": "Boca Juniors",
      "street": "Osimhen Street",
    };
    _ekleneceklerUser["colors"] = FieldValue.arrayUnion(["Sarı", "Kırmızı"]);
    _ekleneceklerUser["createdAdd"] = FieldValue.serverTimestamp();

    await firestore
        .doc("users/$yeniDocId")
        .set(_ekleneceklerUser, SetOptions(merge: true));
  }
}

/*
Firebase firestore noSql bir yapıdadır.Dönüş değeri maptir.

Collection ve document kavramları vardır

Collection tablo anlamına gelir.İçinde documentleri barındırır.

Document dediğimiz veri anlamına gelir içinde field değişkenleri barındırır.

firebase firestore document için bize max 1mb alan verir

doc içine de doc eklenebilir.mesela kullanıncının yaptığı yorumları kullanıcı genel bilgilerinde tutmak saçmadır.
Onun için alt doc oluşturmak çok mantıklıdır.

Veri ekleme iki türlü olur set veya add ile

add:
-eğer sıfırdan bir veri eklemek istiyorsanız add ile eklersiniz.


*/
