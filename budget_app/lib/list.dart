import 'package:flutter/material.dart';
import 'package:budget_app/entries.dart';

class myList extends StatelessWidget {
  Entry entry;
  final void Function()? delete;
  myList({required this.entry, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0)),
          ),
          child:
              Row(
          children:<Widget>[
            Expanded(
              flex:5,
          child:Text("  ${entry.category}  ",
                  style: TextStyle(
                    fontSize: 30,
                    )),
            ),
            Expanded(
              flex:5,
              child:Text("  ${entry.price}  ",
                  style: TextStyle(
                    fontSize: 30,
                  )),
            ),
        Expanded(
        flex:1,
        child:IconButton(onPressed: delete,
          icon:Icon(Icons.delete,size:30,

          ),
        ))]
    )
    ),
      SizedBox(height:30.0)


      ]);
    }
  }

