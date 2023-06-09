import 'package:audioplayers/audioplayers.dart';
import 'package:burdayim/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class AnaSayfa extends StatefulWidget {



  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  var tc = UserInput.tc;
  var name = UserInput.name;

  final oynatici =AudioCache();

  List<String> selectedRooms = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('users');
  TextEditingController _textEditingController = TextEditingController();

  final List<String> roomList = [    'Salon',    'Mutfak',    'Yatak Odası',    'Banyo',    'Çocuk Odası',    'Koridor',  ];



  @override
  Widget build(BuildContext context) {



    void _sendSMS() async {
      String message = "Merhaba, bu bir test mesajıdır!";
      List<String> recipients = ["+905531763742"]; // Alıcı numarası
      String _result = await sendSMS(message: message, recipients: recipients)
          .catchError((onError) {
        print(onError);
        return '';
      });
      print(_result);
    }


    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white10,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/layer3.jpg"),
              fit: BoxFit.cover,
            )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 3.0,
                  ),
                  itemCount: roomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedRooms.contains(roomList[index])) {
                            selectedRooms.remove(roomList[index]);
                          } else {
                            selectedRooms.add(roomList[index]);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedRooms.contains(roomList[index])
                              ? Colors.green
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          roomList[index],
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black26
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30,),


                Row(children:<Widget> [
                  SizedBox(width: 10,),
                  GestureDetector(child: Image.asset("assets/images/location.png",height: 180,width: 180,),
                    onTap: () async {

                      _sendSMS();
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

                      Fluttertoast.showToast(
                        msg: 'Konum bilgileriniz: ${position.latitude}, ${position.longitude}',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                      );



                      FirebaseFirestore.instance.collection('users').doc("Tc:$tc Kişi:$name").set({

                        'Konumum': '${position.latitude}, ${position.longitude}',
                        'Neredeyim': '$selectedRooms',



                      });


                    },
                  ),
                  SizedBox(width: 10),
                  Container(
                  width: 180,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green, // Kutunun arka plan rengi
                    borderRadius: BorderRadius.circular(10), // Kutunun köşe yarıçapı
                  ),
                  child: InkWell(
                    onTap: () async {

                      _sendSMS();
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

                      Fluttertoast.showToast(
                        msg: 'Konum bilgileriniz: ${position.latitude}, ${position.longitude}',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                      );



                      FirebaseFirestore.instance.collection('users').doc("Tc:$tc Kişi:$name").set({

                        'Konumum': '${position.latitude}, ${position.longitude}',
                        'Neredeyim': '$selectedRooms',



                      });


                    },

                    child: Center(
                      child: Text(
                        'Konumumu İlet',
                        style: TextStyle(
                          color: Colors.white, // Metin rengi
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

SizedBox(height: 240,)
                ],

                ),

                SizedBox(height: 30,),
                Row(children:<Widget> [
                  SizedBox(width: 22,),
                  GestureDetector(child: Image.asset("assets/images/uyari.png",height: 160,width: 160,),
                    onTap: ()   {
                       oynatici.play("aa.mp3");

                    },
                  ),
                  SizedBox(width: 18,),
                  Container(

                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green, // Kutunun arka plan rengi
                      borderRadius: BorderRadius.circular(10), // Kutunun köşe yarıçapı
                    ),
                    child: InkWell(

                      onTap: () async {
                        oynatici.play("aa.mp3");

                      },

                      child: Center(
                        child: Text(
                          'Zili Çal',
                          style: TextStyle(
                            color: Colors.white, // Metin rengi
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),


                ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



