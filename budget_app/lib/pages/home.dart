import 'package:flutter/material.dart';
import 'package:budget_app/entries.dart';
import 'package:budget_app/pages/expense.dart';
class Home extends StatefulWidget {
  List<Entry> expenses = [];
  int total=0;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {



  @override
  void initState() {
    super.initState();
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
                        builder: (context) => Expense(expenses: widget.expenses,total:widget.total),
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
