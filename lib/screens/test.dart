import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// import 'login_page.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 300,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Your Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                      child: Icon(
                        Icons.email,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(color: Colors.black),
                        gapPadding: 10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: Colors.black),
                      gapPadding: 10,
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 300,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Your Password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                    child: Icon(
                      Icons.password,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: Colors.black),
                      gapPadding: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Colors.black),
                    gapPadding: 10,
                  )),
            ),
          ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  onPrimary: Color(0xFFFF7643),
                  elevation: 5,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              // ignore: prefer_const_constructors
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Adminlogin();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future Adminlogin() async {
    String url =
        'https://presentatiobackend.khybergolfcity.com/auth/staff/login';
    var data = {
      'cnic': emailController.text,
      'password': passwordController.text,
    };
    var result = await http.post(Uri.parse(url), body: jsonEncode(data));
  }
}
