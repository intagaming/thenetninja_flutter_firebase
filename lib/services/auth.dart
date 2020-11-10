import 'package:brew_crew/models/brew_user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BrewUser _userFromFirebaseUser(User u) {
    return u != null ? BrewUser(uid: u.uid) : null;
  }

  Stream<BrewUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<BrewUser> signInAnon() async {
    try {
      UserCredential uc = await _auth.signInAnonymously();
      User user = uc.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<BrewUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User u = uc.user;
      return _userFromFirebaseUser(u);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<BrewUser> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User u = uc.user;
      await DatabaseService(uid: u.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(u);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}