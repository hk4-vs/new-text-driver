import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_texi_driver/models/driver_user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../utils/routes/route_names.dart';

class AuthViewModel with ChangeNotifier {
  // static UserModel? _user = UserModel();

  // static UserModel? get user => _user;
  // setUserMode(UserModel user){
  //   _user = user;
  //   notifyListeners();
  // }
  DriverUserModel _driverUserModel = DriverUserModel();
  get driverUserModel => _driverUserModel;
  setDriverUserModel(DriverUserModel value) {
    _driverUserModel = value;
    notifyListeners();
  }

  isAlreadyLoggedIn({required BuildContext context}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      log("user: ${user.uid}");
      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(user.uid)
          .get()
          .then((value) {
        DriverUserModel userModel = DriverUserModel.fromMap(value.data()!);
        setDriverUserModel(userModel);
        log("already logged in");
        Navigator.pushReplacementNamed(context, RouteNames.dashboard,
            arguments: {'driver': userModel});
      });
      // setUserMode(userModel);
    } else {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.login,
      );
    }
  }

  showLogoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteNames.login, (route) => false);
                  },
                  child: Text("Yes"),
                )
              ]);
        });
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
