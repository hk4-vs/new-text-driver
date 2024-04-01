import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_texi_driver/models/driver_user_model.dart';
import 'package:provider/provider.dart';

import '../utils/routes/route_names.dart';
import '../utils/utils.dart';
import 'auth_view_model.dart';

class RegistrationNewPageViewModel with ChangeNotifier {
  String? _drivingLicenseImageUrl;
  String? _vehicleImageUrl;
  String? _vehicleDocumentImageUrl;
  String? _yourImage;

  bool _drivingLicenseUplodate = false;
  bool _vehicleImageUrlUplodate = false;
  bool _vehicleDocumentImageUrlUplodate = false;
  bool _yourImageUplodate = false;

  bool get drivingLicenseUplodate => _drivingLicenseUplodate;
  bool get vehicleImageUrlUplodate => _vehicleImageUrlUplodate;
  bool get vehicleDocumentImageUrlUplodate => _vehicleDocumentImageUrlUplodate;
  bool get yourImageUplodate => _yourImageUplodate;

  bool _submitButton = false;

  bool get submitButton => _submitButton;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  setLoding(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setDrivingLicenseUplodate(bool value) {
    _drivingLicenseUplodate = value;
    notifyListeners();
  }

  setVehicleImageUrlUplodate(bool value) {
    _vehicleImageUrlUplodate = value;
    notifyListeners();
  }

  setVehicleDocumentImageUrlUplodate(bool value) {
    _vehicleDocumentImageUrlUplodate = value;
    notifyListeners();
  }

  setYourImageUplodate(bool value) {
    _yourImageUplodate = value;
    notifyListeners();
  }

  String? get drivingLicenseImageUrl => _drivingLicenseImageUrl;

  setDrivingLicenseImageUrl(String? value) {
    _drivingLicenseImageUrl = value;
    if (value != null) {
      setDrivingLicenseUplodate(true);
      showSubmitButton();
    }
    notifyListeners();
  }

  String? get vehicleImageUrl => _vehicleImageUrl;

  setVehicleImageUrl(String? value) {
    _vehicleImageUrl = value;
    if (value != null) {
      setVehicleImageUrlUplodate(true);
      showSubmitButton();
    }
    notifyListeners();
  }

  String? get vehicleDocumentImageUrl => _vehicleDocumentImageUrl;

  setVehicleDocumentImageUrl(String? value) {
    _vehicleDocumentImageUrl = value;
    if (value != null) {
      setVehicleDocumentImageUrlUplodate(true);
      showSubmitButton();
    }
    notifyListeners();
  }

  String? get yourImage => _yourImage;

  setYourImage(String? value) {
    _yourImage = value;
    if (value != null) {
      setYourImageUplodate(true);
      showSubmitButton();
    }
    notifyListeners();
  }

  showSubmitButton() {
    if (drivingLicenseUplodate &&
        vehicleImageUrlUplodate &&
        vehicleDocumentImageUrlUplodate &&
        yourImageUplodate) {
      _submitButton = true;
      notifyListeners();
    }
  }

  registerAccount(
      {required DriverUserModel driverUserModel,
      required BuildContext context}) async {
    setLoding(true);

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      GoogleSignInAccount? googleSignInAccount = googleSignIn.currentUser;
      if (googleSignInAccount != null) {
        String email = googleSignInAccount.email;
        if (email.isNotEmpty) {
          log('Email already exists: $email');
          String? uid = googleSignInAccount.id.toString();
          driverUserModel.uid = uid;
          log("uid: $uid");

          storeDriverDataToFireStore(newUser: driverUserModel);

          log("uid after firestore: $uid");
          Provider.of<AuthViewModel>(context, listen: false)
              .setDriverUserModel(driverUserModel);
          setLoding(false);
          Navigator.pushNamedAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              RouteNames.dashboard,
              (Route<dynamic> route) => false,
              arguments: {
                'driver': driverUserModel,
              });
        } else {
          print('No email found');
        }
      } else {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: driverUserModel.email!,
                password: driverUserModel.password!);

        if (userCredential.user!.email!.isNotEmpty) {
          String? uid = userCredential.user!.uid.toString();
          driverUserModel.uid = uid;
          log("uid: $uid");

          storeDriverDataToFireStore(newUser: driverUserModel);

          log("uid after firestore: $uid");
          Provider.of<AuthViewModel>(context, listen: false)
              .setDriverUserModel(driverUserModel);
          setLoding(false);
          Navigator.pushNamedAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              RouteNames.dashboard,
              (Route<dynamic> route) => false,
              arguments: {
                'driver': driverUserModel,
              });
        }
      }
    } on FirebaseAuthException catch (e) {
      setLoding(false);
      Utils.toastMessage(e.message.toString());
    } catch (e) {
      setLoding(false);
      Utils.toastMessage(e.toString());
    }
  }

  storeDriverDataToFireStore({required DriverUserModel newUser}) async {
    await FirebaseFirestore.instance
        .collection("drivers")
        .doc(newUser.uid.toString())
        .set(newUser.toMap());
  }
}
