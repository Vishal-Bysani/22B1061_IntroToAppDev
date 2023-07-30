import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'graphs.dart';
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
  bool ascendingOrder = false; // A boolean variable to keep track of the sorting order

  void sortExpenses() {
    setState(() {
      if (ascendingOrder) {
        widget.expenses.sort((a, b) => a.price.abs().compareTo(b.price.abs())); // Sort in ascending order
      } else {
        widget.expenses.sort((a, b) => b.price.abs().compareTo(a.price.abs())); // Sort in descending order
      }
      ascendingOrder = !ascendingOrder; // Toggle the sorting order for the next tap
    });
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
          actions: [
            IconButton(onPressed: (){
              setState(() {
                sortExpenses();
              });
            }, icon: Icon(Icons.sort),
            tooltip: "Sort the expenses by value",)
          ],
        ),
        backgroundColor: Colors.lightBlue[100],
        floatingActionButton: Transform.scale(
            scale: 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Row(
                children: <Widget>[FloatingActionButton(
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
                  FloatingActionButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Graph(expenses: widget.expenses, total: widget.total)),
                    );
                  },
                  child: Icon(Icons.auto_graph_sharp),
                    backgroundColor: Colors.white70,
                    foregroundColor: Colors.deepPurple[300],
                  )

               ])
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
          SizedBox(height: 30.0,),
          Expanded(
            child: ListView.builder(
              itemCount: widget.expenses.length,
              itemBuilder: (context, index) {
                final expense = widget.expenses[index];

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      widget.expenses.removeAt(index);
                      calculateTotal();
                      dbase.deleteEntry(expense.category, expense.price);
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('${expense.category} dismissed')));
                  },
                  child: myList(
                    entry: expense,
                    delete: () {
                      setState(() {
                        widget.expenses.remove(expense);
                        calculateTotal();
                        dbase.deleteEntry(expense.category, expense.price);
                      });
                    },
                  ),
                );
              },
            ),
          ),

        ]));
  }
}
