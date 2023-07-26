import 'package:budget_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/pages/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:budget_app/models/user.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<Users?>(context);
    //return Home or Authenticate page
    if(user==null)
      return Authenticate();
    else
      return Home(uid: user.uid);
  }
}
