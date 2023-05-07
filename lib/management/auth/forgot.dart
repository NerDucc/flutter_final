import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widget/reuse.dart';
import '../route_names.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.lightGreenAccent,Colors.white,Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            )
          ),
          child: SingleChildScrollView(
            child:  Padding(
              padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    const Icon(
                        Icons.lock,
                        size: 120,
                        color: Colors.black,
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Email" ,Icons.person, false, _emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(context, "Reset Password", (){
                      FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).then((value) => Navigator.of(context).pop());
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],  
                ),
              )),
          ),
        ),
    )
    );
  }
}