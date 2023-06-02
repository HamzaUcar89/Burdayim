import 'package:burdayim/signup.dart';
import 'package:burdayim/main.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'authhentication.dart';

class Giris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/layer2.jpg"),
              fit: BoxFit.cover,
            )
        ),
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              SizedBox(height: 80),
              // logo
              Column(
                children: [
                  Image.asset("assets/images/location.png",width: 400,height: 200,),
                  SizedBox(height: 50),
                  Text(
                    'Hoşgeldiniz',
                    style: TextStyle(fontSize: 24,color: Colors.green),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: LoginForm(),
              ),

              SizedBox(height: 40),

              Row(
                children: <Widget>[
                  SizedBox(width: 70),
                  Text('Hesabın Yok Mu ?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.green)),SizedBox(width: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Kayit()));
                    },
                    child: Text('Kayıt ol !!',
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            // initialValue: 'Input text',
            decoration: InputDecoration(iconColor: Colors.green,
              prefixIcon: Icon(Icons.email_outlined,color: Colors.green,),
              labelText: 'E-posta',labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Lütfen E-postanızı Giriniz';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
          ),
          SizedBox(
            height: 20,
          ),

          // password
          TextFormField(
            // initialValue: 'Input text',
            decoration: InputDecoration(
              labelText: 'Şifre',
              labelStyle: TextStyle(color: Colors.green),
              prefixIcon: Icon(Icons.lock_outlined,color: Colors.green,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
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
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Lütfen Şifrenizi Giriniz';
              }
              return null;
            },
          ),

          SizedBox(height: 30),

          SizedBox(
            height: 54,
            width: 184,
            child: ElevatedButton(
              onPressed: () {


                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signIn(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text(
                'Giriş Yap',
                style: TextStyle(fontSize: 26,color: Colors.white),
              ),

            ),
          ),
        ],
      ),
    );
  }
}