import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../models/driver_user_model.dart';
import '../models/user_model.dart';
import '../utils/routes/route_names.dart';
import '../utils/utils.dart';
import '../views/register_new_page.dart';
import 'auth_view_model.dart';
import 'registration_new_page_view_model.dart';

class FirebaseAuthViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoding(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signInWithGoogle({
    required BuildContext context,
  }) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        log("googleUser: $googleUser");
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        log("userCredential: ${userCredential.user}");
        // DriverUserModel userModel = DriverUserModel(
        //   uid: userCredential.user!.uid,
        //   name: userCredential.user!.displayName,
        //   email: userCredential.user!.email,

        //   password: "123456",

        // );
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("drivers")
            .where("email", isEqualTo: userCredential.user!.email)
            .get();

        log("querySnapshot: $querySnapshot");

        if (querySnapshot.docs.isEmpty) {
          log("new user");
          //  navigate to registration page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterNewPage(
                email: userCredential.user!.email.toString(),
                password: "123456",
              ),
            ),
          );
        } else {
          log("old user");
          //  navigate to dashboard
          DriverUserModel userModel = DriverUserModel.fromMap(
              querySnapshot.docs.first.data() as Map<String, dynamic>);
          log("userModel: $userModel");
          Utils.toastMessage("Google login success");
          Provider.of<AuthViewModel>(context, listen: false)
              .setDriverUserModel(userModel);
          Navigator.pushNamedAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              RouteNames.dashboard,
              (Route<dynamic> route) => false,
              arguments: {
                'driver': userModel,
              });
        }
        //  store driver data to firestore
      } else {
        log("google sign in failed");
        Utils.toastMessage("Google sign in failed");
      }
    } catch (e) {
      log("error: $e");
      // Handle sign-in errors
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // Future<void> signInWithGoogle({
  //   required BuildContext context,
  // }) async {
  //   GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

  //   OAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   log("credential: $credential");
  // }

  Future<void> checkIfEmailExists(String email) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: "randomPassword");
      print('Email does not exist');
      // If the email does not exist, the user account will be created successfully
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email already exists');
        // Handle the case where the email already exists
      }
    }
  }

  Future<UserModel?> getUserDataFromFireStore({required String uid}) async {
    UserModel user = UserModel();
    var documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (documentSnapshot.data() != null) {
      user = UserModel.fromMap(documentSnapshot.data()!);
      return user;
    }
  }

  loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    setLoding(true);
    UserCredential? userCredential;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("drivers")
          .where('email', isEqualTo: email)
          .get();
      DriverUserModel userModel = DriverUserModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      if (querySnapshot.docs.isEmpty) {
        Utils.toastMessage("Email does not exist");
      } else {
        if (userModel.password == password) {
          userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          Provider.of<AuthViewModel>(context, listen: false)
              .setDriverUserModel(userModel);
          Utils.toastMessage("Login successful");
          Navigator.pushNamedAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              RouteNames.dashboard,
              (Route<dynamic> route) => false,
              arguments: {
                'driver': userModel,
              });
        } else {
          Utils.toastMessage("Credentials does not match");
        }
      }
      setLoding(false);
    } on FirebaseAuthException catch (e) {
      setLoding(false);
      Utils.toastMessage(e.message.toString());
    } catch (e) {
      setLoding(false);
      Utils.toastMessage(e.toString());
    }
  }
}
