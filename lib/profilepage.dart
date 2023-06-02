import 'package:burdayim/login.dart';
import 'package:burdayim/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class SecondPage extends StatefulWidget {
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var name = UserInput.name;

  var tc = UserInput.tc;

  var email = FirebaseAuth.instance.currentUser?.email.toString();

  var gsm = UserInput.gsm;

  var konum = "Konumunuzu görmek için tıklayınız";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: Container(
       decoration: BoxDecoration(
       image: DecorationImage(
          image: AssetImage("assets/images/layer1.jpg"),
       fit: BoxFit.cover,
       )
       ),
       child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
            ListTile(
              leading: Icon(Icons.person,size: 40,),
              title: Text(
                ': $name',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 30),
            ListTile(leading: Icon(Icons.perm_identity,size: 40,),
              title: Text(
                ': $tc',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 30),


            ListTile(
              leading: Icon(Icons.email,size: 40,),
              title: Text(
                ': $email',
                style: TextStyle(fontSize: 30,),
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.phone,size: 40,),
              title: Text(
                ': $gsm',
                style: TextStyle(fontSize: 30,),
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.location_on,size: 40,),
              title:GestureDetector(child: Text(": $konum",
                style: TextStyle(fontSize: 30,),
              ),
                  onTap:() async {
                LocationPermission permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                  if (permission == LocationPermission.denied) {
                    Fluttertoast.showToast(
                      msg: 'Konum izni verilmedi!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                    );
                    return;
                  }
                }
                Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                );

                setState(() {
                  konum= "${position.latitude},${position.longitude}";
                });

              } ),
            ),
            SizedBox(height: 24),
            ElevatedButton(style: ElevatedButton.styleFrom(
              primary: Colors.green, // Arka plan rengini burada belirtin
            ),
              onPressed: () {
                // Profil düzenleme işlemleri burada gerçekleştirilebilir.
              },
              child: Text(
                'Profili Düzenle',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ElevatedButton(style: ElevatedButton.styleFrom(
            primary: Colors.red, // Arka plan rengini burada belirtin
          ),
            onPressed: () {
              _signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Giris()));
            },
            child: Text('Çıkış Yap', style: TextStyle(
              fontSize: 16,color: Colors.white
            ),),

          )],
        ),
      ),
      ),
    );
  }
}
