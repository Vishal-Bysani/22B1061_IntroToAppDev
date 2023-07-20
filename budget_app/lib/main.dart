import 'package:flutter/material.dart';
import 'package:budget_app/pages/home.dart';
import 'package:budget_app/pages/expense.dart';
import 'package:budget_app/entries.dart';
void main() {

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home':(context)=>Home(),
      '/expense':(context){
        final args = ModalRoute.of(context)!.settings.arguments;
        final List<Entry> expenses = (args as List<Entry>?) ?? [];
        final int total= (args as int?) ?? 0;
        return Expense(expenses: expenses,total:total);
      }
    },
  ));

}
