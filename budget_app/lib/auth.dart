import 'package:budget_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_app/models/user.dart';

class AuthService{

  final FirebaseAuth _auth= FirebaseAuth.instance;
  //create user obj based on User
  Users? _userFromUser(User? user){
    return user!=null ? Users(uid: user.uid):null;
  }

  //auth change user stream
  Stream<Users?> get user{
    return _auth.authStateChanges().map((User? user)=> _userFromUser(user));
  }

  //sign in anonymously
  Future signInAnon()async{
    try{
      UserCredential result=await _auth.signInAnonymously();
      User? user=result.user;
      return _userFromUser(user);
    }
    catch(e)
    {
        print(e.toString());
        return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email,String password)async{
      try{
        UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password);
        User? user=result.user;
        return _userFromUser(user);
      }
      catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=result.user;

      //create a new document for the user with that uid
      if (user!=null)
      await DatabaseService(uid: user.uid).updateUserData('Grocery', -500);
      return _userFromUser(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut()async{
    try{
      return await _auth.signOut();
    }
    catch(e){
        print(e.toString());
        return null;
    }
  }
}