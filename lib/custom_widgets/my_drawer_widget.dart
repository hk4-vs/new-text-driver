import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_texi_driver/custom_widgets/display_image_from_firebase_storage_widget.dart';
import 'package:new_texi_driver/models/driver_user_model.dart';
import 'package:provider/provider.dart';

import '../models/my_variables.dart';
import '../utils/routes/route_names.dart';
import '../view-models/auth_view_model.dart';

class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DriverUserModel driverUserModel =
        Provider.of<AuthViewModel>(context, listen: false).driverUserModel;
    log("driverUserModel: ${driverUserModel.uid}");
    return Drawer(
      width: MyVariables.width(context) * 0.6,
      child: Column(
        children: [
          DrawerHeader(
              child: CircleAvatar(
            radius: 50,
            child: driverUserModel.profilePic == ""
                ? Icon(Icons.person)
                : DisplayImageFromFirebaseStorageWidget(
                    url: driverUserModel.profilePic!,
                  ),
          )),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.bookingHistroyView,
                );
              },
              child: const Text("Booking History")),
          TextButton(
              onPressed: () {
                AuthViewModel().showLogoutDialog(context);
              },
              child: const Text("Logout")),
        ],
      ),
    );
  }
}
