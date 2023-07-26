import 'package:budget_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/entries.dart';
import 'package:budget_app/pages/expense.dart';
import 'package:budget_app/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Home extends StatefulWidget {
  List<Entry> expenses = [Entry(category: 'Grocery',price: -500)];
  int total=0;
  String uid;
  Home({required this.uid});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final AuthService _auth = AuthService();

  Future<void> fetchExpensesData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .doc(widget.uid)
          .collection('user_entries')
          .get();

      List<Entry> fetchedExpenses = [];

      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        fetchedExpenses.add(Entry(
          category: data['category'] as String,
          price: data['price'] as int,
        ));
      });

      setState(() {
        widget.expenses = fetchedExpenses;
        calculateTotal();
      });
    } catch (e) {
      // Handle any errors that occur during data fetching
      print('Error fetching expenses data: $e');
    }
  }


  @override

  void initState() {
    super.initState();
    fetchExpensesData();
    calculateTotal();

  }
  void calculateTotal() {
    widget.total = 0;
    for (int i = 0; i < widget.expenses.length; i++) {
      widget.total += int.tryParse(widget.expenses[i].price.toString()) ?? 0;
    }
  }

  Widget build(BuildContext context) {

    return  Scaffold(
        appBar: AppBar(
            title: Text("Budget Tracker",
                style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                )),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blue[400],
          actions: <Widget>[
            TextButton.icon(onPressed: ()async{
              await _auth.signOut();
            },
                icon: Icon(Icons.person,
                color: Colors.black,),
                label:Text("Logout",
                style: TextStyle(
                  color: Colors.white
                )))
          ],
        ),
        backgroundColor: Colors.lightBlue[100],

        body: Padding(
          padding: const EdgeInsets.fromLTRB(20,30,30,0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              CircleAvatar(child:Center(child:Icon(Icons.person_2,
              size:200)),
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              radius:100),
              SizedBox(height: 30.0,),
              Text("Welcome\n    Back!",
              style: TextStyle(
                fontSize: 45,
              )),
              SizedBox(height:60.0),
              Container(

                  decoration: BoxDecoration(
                    color: Colors.white70,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
              ),
                child: Row(
                    children: <Widget>[
                      Expanded(
                flex: 1,
                    child:Text("    Total:   ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,

                ))),
                      Expanded(
                          flex: 1,
                          child:Text("    ${widget.total}   ",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,

                              ))),
                SizedBox(width:300),
                IconButton(
                    onPressed: ()async{
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Expense(expenses: widget.expenses,total:widget.total,uid : widget.uid),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          widget.expenses = result['expenses'];
                          widget.total=result['total'];

                        });
                      }
                    },
                    icon: Icon(Icons.keyboard_double_arrow_down_rounded),
                  tooltip: "Click if you want to modify the list",
                )
              ]
                )
              )

            ],
          ),
        )

    );
  }
}
