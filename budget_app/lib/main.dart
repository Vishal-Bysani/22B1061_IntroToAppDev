import 'package:budget_app/auth.dart';
import 'package:budget_app/models/user.dart';
import 'package:budget_app/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/pages/home.dart';
import 'package:budget_app/pages/expense.dart';
import 'package:budget_app/entries.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(StreamProvider<Users?>.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
      home: Wrapper()
      // initialRoute: '/wrapper',
      // routes: {
      //   '/wrapper':(context)=>Wrapper(),
      //   '/home':(context)=>Home(),
      //   '/expense':(context){
      //     final args = ModalRoute.of(context)!.settings.arguments;
      //     final List<Entry> expenses = (args as List<Entry>?) ?? [];
      //     final int total= (args as int?) ?? 0;
      //     return Expense(expenses: expenses,total:total);
      //   }
      // },
    ),
  ));

}
