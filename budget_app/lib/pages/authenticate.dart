import 'package:budget_app/pages/register.dart';
import 'package:budget_app/pages/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn=true;
  void toggleView()
  {
    setState(() {
      showSignIn=!showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn)
      return SignIn(toggleView: toggleView);
    else
      return Register(toggleView: toggleView);
  }
}
