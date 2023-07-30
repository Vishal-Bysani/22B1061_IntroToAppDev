import 'package:budget_app/share/constants.dart';
import 'package:budget_app/share/loading.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/auth.dart';
import 'authenticate.dart';
class Register extends StatefulWidget {
  final Function  toggleView;
  Register({required this.toggleView});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email='';
  String password='';
  String error='';
  bool loading=false;
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
        appBar: AppBar(
          title: Text("Sign-Up To Budget App",
          style: TextStyle(
            fontSize: 30.0
          ),),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(onPressed:(){
                widget.toggleView();
              }, icon: Icon(Icons.person,
              color: Colors.black,),
                  label: Text("Sign In",
                  style: TextStyle(
                    color: Colors.white
                  ),))
            ]
        ),
        backgroundColor: Colors.lightBlue[100],
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: Form(
            key:_formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val){
                    if (val == null || val.isEmpty) {
                      return 'Enter an email'; // Return an error message if the input is empty or null.
                    }
                    return null;
                  },
                  onChanged: (val){
                    setState(() {
                      email=val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val){
                    if (val == null || val.length<6) {
                      return 'Enter a password 6+ characters long'; // Return an error message if the input is empty or null.
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (val){
                    setState(() {
                      password=val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(onPressed: ()async{
                  if(_formKey.currentState?.validate() ?? false)
                    {
                      setState(() {
                        loading=true;
                      });
                      dynamic result= await _auth.registerWithEmailAndPassword(email, password);
                      if(result==null)
                        setState(() {
                          error="Please supply valid email";
                          loading=false;
                        });

                    }
                },
                    child:Text("Register",
                        style:TextStyle(
                            color: Colors.white70,
                          fontSize: 20.0
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent[400], // Set the background color to pink
                    )),
                SizedBox(height: 12.0,),
                Text(error,
                style: TextStyle(
                  color: Colors.red,fontSize: 14.0
                ),)
              ],
            ),
          ),
        )
    );;
  }
}
