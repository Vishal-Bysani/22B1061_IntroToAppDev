import 'dart:math';

import 'package:flutter/material.dart';
import 'package:budget_app/list.dart';
import 'package:budget_app/entries.dart';
import 'package:budget_app/database.dart';


class PopupWidget extends StatefulWidget {

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  String category = '';
  int price = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Entry',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
        color:Colors.white70
      )),
      backgroundColor: Colors.blue[400],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                category = value;
              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
            enabledBorder: InputBorder.none  ,
            labelText: 'Category',
              labelStyle: TextStyle(color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                price = int.tryParse(value) ?? 0;
              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: InputBorder.none  ,labelText: 'Price',
              labelStyle: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop({'category': category, 'price': price});
          },
          icon: Icon(Icons.check_circle_rounded,
          ),
        ),
      ],
    );
  }
}

class Expense extends StatefulWidget {
  final List<Entry> expenses;

  int total=0;
  String uid;
  Expense({required this.expenses,required this.total,required this.uid});


  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {

  late DatabaseService dbase;
  @override
  void initState() {
    super.initState();
    dbase=DatabaseService(uid: widget.uid);
    calculateTotal();
  }

  void calculateTotal() {
    widget.total = 0;
    for (int i = 0; i < widget.expenses.length; i++) {
      widget.total += int.tryParse(widget.expenses[i].price.toString()) ?? 0;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed:  (){
              Navigator.pop(context,{"expenses":widget.expenses,"total":widget.total});
            },

          ),
          title: Text("Budget Tracker",
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blue[400],
        ),
        backgroundColor: Colors.lightBlue[100],
        floatingActionButton: Transform.scale(
            scale: 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PopupWidget();
                        });
                    if (result != null) {
                      setState(() {
                        widget.expenses.add(Entry(
                          category: result['category'],
                          price: result['price'],
                        ));
                        calculateTotal();
                        dbase.addEntry(result['category'], result['price']);

                      });
                    }
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.deepPurple[300],
                ),


              ],
            )),
        body: Column(children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
              ),
              child: Row(children: <Widget>[
                Text(
                    "    Total:                                                 ${widget.total}                 ",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 300),

              ])),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.expenses
                    .map((expense) => myList(
                        entry: expense,
                        delete: () {
                          setState(() {
                            widget.expenses.remove(expense);
                            calculateTotal();
                            dbase.deleteEntry(expense.category, expense.price);

                          });
                        }))
                    .toList()),
          ),
        ]));
  }
}
