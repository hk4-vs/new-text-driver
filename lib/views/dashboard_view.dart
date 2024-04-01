import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_texi_driver/custom_widgets/my_drawer_widget.dart';
import 'package:new_texi_driver/models/book_ride_model.dart';
import 'package:new_texi_driver/models/driver_user_model.dart';

import '../custom_widgets/booking_histry_card_widget.dart';
import '../custom_widgets/dashboar_card_view_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.user});
  final DriverUserModel user;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [Switch.adaptive(value: true, onChanged: (value) {})],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("bookings")
            .where("driverId", isEqualTo: "0")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          var docs = snapshot.data!.docs;
          List<BookRideModel> list =
              docs.map((e) => BookRideModel.fromMap(e.data())).toList();

          if (list.isEmpty) {
            return const Center(child: Text("No Bookings Found"));
          }
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return DashboardCardView(
                  bookingHistry: list[index],
                  driverId: widget.user.uid.toString(),
                );
              });
        },
      ),
    );
  }
}
