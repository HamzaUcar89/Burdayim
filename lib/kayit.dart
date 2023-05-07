import 'package:burdayim/giris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authhentication.dart';

class Kayit extends StatefulWidget {

  @override
  State<Kayit> createState() => _KayitState();
}

class _KayitState extends State<Kayit> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(backgroundColor: Colors.blueGrey,
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(height: 40),
            // logo

            SizedBox(height: 30),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignupForm(),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[SizedBox(width: 30,),
                      Text('Zaten Hesabın Var Mı ?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white)),SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(' Giriş Yap',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildLogo() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Center(
        child: Text(
          "T",
          style: TextStyle(color: Colors.white, fontSize: 60.0),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;


  String? email;
  String? password;
  String? name;
  String? tc;
  bool _obscureText = false;

  bool agree = false;

  final pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(100.0),
      ),
    );

    var space = SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            decoration: InputDecoration(

                labelText: 'E-posta',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.email_outlined,color: Colors.white,),
                border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Lütfen E-postanızı Giriniz';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),SizedBox(height: 10),

          space,

          // password
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              labelText: 'Şifre',

              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.lock_outlined,color: Colors.white,),
              border: border,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Lütfen Şifrenizi Giriniz';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          space,
          // confirm passwords
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Şifre(Tekrar)',
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.lock_outlined,color: Colors.white,),
              border: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'Şifreler Uyuşmuyor';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          space,
          // name
          TextFormField(
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.account_circle,color: Colors.white),
              labelText: 'TC kimlik numaranız',

              border: border,
            ),
            onSaved: (val) {
              UserInput.tc = val.toString();
              tc = val;
              },
            validator: (value) {
              if (value!.isEmpty) {
                return 'TC kimlik Bilgilerinizi Giriniz';
              }
              return null;
            },
          ),SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.account_circle,color: Colors.white),
              labelText: 'Adınız Soyadınız',

              border: border,
            ),
            onSaved: (val) {
              UserInput.name = val.toString();
              name = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Adınızı Soyadınızı Giriniz';
              }
              return null;
            },
          ),SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (_) {
                  setState(() {
                    agree = !agree;
                  });
                },
                value: agree,
              ),
              Flexible(
                child: Text(
                    'Hesap oluşturarak, Şartlar ve Koşullar ile Gizlilik Politikasını kabul ediyorum.',style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          // signUP button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signUp(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Giris()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text('Kayıt Ol',style: TextStyle(color: Colors.black,fontSize:22),),
            ),
          ),
        ],
      ),
    );
  }
}
class UserInput {
  static String tc = 'anonymus';
  static String name = "anonymus";
}