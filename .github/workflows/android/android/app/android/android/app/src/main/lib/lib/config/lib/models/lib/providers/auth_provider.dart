import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  String? _userRole;
  bool _isLoading = true;
  String? _error;

  UserModel? get user => _user;
  String? get userRole => _userRole;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user != null) {
        await _fetchUserData(user.uid);
      }
    } catch (e) {
      _error = e.toString();
      print('Auth check error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> studentSignUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int age,
    required String parentName,
    required String parentPhone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: 'student',
        age: age,
        parentName: parentName,
        parentPhone: parentPhone,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(_user!.uid).set(_user!.toMap());

      _userRole = 'student';
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> trainerSignUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String category,
    required String experience,
    required String location,
    required String classroomType,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: 'trainer',
        category: category,
        experience: experience,
        location: location,
        classroomType: classroomType,
        verified: false,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(_user!.uid).set(_user!.toMap());

      _userRole = 'trainer';
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _fetchUserData(_auth.currentUser!.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        _userRole = _user!.role;
      }
    } catch (e) {
      _error = e.toString();
      print('Fetch user error: $e');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _userRole = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      default:
        return 'An error occurred: $code';
    }
  }
}
